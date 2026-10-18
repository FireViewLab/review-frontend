import 'dart:async';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'hero_banner_controls.dart';
import 'hero_banner_card.dart';

class HeroBannerCarousel extends StatefulWidget {
  const HeroBannerCarousel({
    required this.items,
    this.onBannerPressed,
    super.key,
  });

  final List<HomeBannerData> items;
  final ValueChanged<HomeBannerData>? onBannerPressed;

  @override
  State<HeroBannerCarousel> createState() => _HeroBannerCarouselState();
}

class _HeroBannerCarouselState extends State<HeroBannerCarousel> {
  late PageController _controller;
  Timer? _autoTimer;
  double _viewportFraction = .46;
  int _currentPage = 0;
  int _activeIndex = 0;
  int _targetPage = 0;
  int _moveRequest = 0;
  bool _isPaused = false;
  bool _isMoving = false;
  bool _isInteracting = false;
  bool _hovered = false;
  bool _reduceMotion = false;
  bool _ticksEnabled = true;
  ScrollPosition? _outerScroll;

  void _onOuterScrollActivity() {
    if (_outerScroll?.isScrollingNotifier.value == true) {
      _autoTimer?.cancel();
    } else {
      _scheduleAuto();
    }
  }

  bool get _isVisible {
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return false;
    final rect = box.localToGlobal(Offset.zero) & box.size;
    return rect.overlaps(Offset.zero & MediaQuery.sizeOf(context));
  }

  @override
  void initState() {
    super.initState();
    _currentPage = _initialPageFor(widget.items.length);
    _targetPage = _currentPage;
    _activeIndex = _realIndexFor(_currentPage);
    _controller = PageController(
      viewportFraction: _viewportFraction,
      initialPage: _currentPage,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final outerScroll = Scrollable.maybeOf(context)?.position;
    if (!identical(outerScroll, _outerScroll)) {
      _outerScroll?.isScrollingNotifier.removeListener(_onOuterScrollActivity);
      _outerScroll = outerScroll;
      _outerScroll?.isScrollingNotifier.addListener(_onOuterScrollActivity);
    }
    _ticksEnabled = TickerMode.valuesOf(context).enabled;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (reduceMotion && !_reduceMotion && _isMoving) {
      _moveRequest++;
      _isMoving = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _reduceMotion && _controller.hasClients) {
          _controller.jumpToPage(_currentPage);
        }
      });
    }
    _reduceMotion = reduceMotion;
    final width = context.viewportSize.width;
    final nextFraction = context.isMobile
        ? .88
        : (width < 900
              ? .82
              : (width < 1200 ? .68 : (width < 1600 ? .46 : .36)));
    if (nextFraction != _viewportFraction) {
      _currentPage = _controller.hasClients
          ? (_controller.page ?? _currentPage.toDouble()).round()
          : _currentPage;
      _targetPage = _currentPage;
      _moveRequest++;
      _isMoving = false;
      _viewportFraction = nextFraction;
      _controller.dispose();
      _controller = PageController(
        viewportFraction: nextFraction,
        initialPage: _currentPage,
      );
    }
    // Initial visibility is available only after layout. No per-pixel listener.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scheduleAuto();
    });
  }

  @override
  void didUpdateWidget(covariant HeroBannerCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length == widget.items.length) return;
    _moveRequest++;
    _isMoving = false;
    _currentPage = _initialPageFor(widget.items.length);
    _targetPage = _currentPage;
    _activeIndex = _realIndexFor(_currentPage);
    _controller.dispose();
    _controller = PageController(
      viewportFraction: _viewportFraction,
      initialPage: _currentPage,
    );
    _scheduleAuto();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) {
        final mobileHeight =
            (constraints.maxWidth * _viewportFraction - AppSpacing.md) /
            (1916 / 821);
        return MouseRegion(
          onEnter: (_) {
            _hovered = true;
            _autoTimer?.cancel();
          },
          onExit: (_) {
            _hovered = false;
            _scheduleAuto();
          },
          child: Listener(
            onPointerDown: (_) => _autoTimer?.cancel(),
            onPointerUp: (_) => _scheduleAuto(),
            onPointerCancel: (_) => _scheduleAuto(),
            child: SizedBox(
              height: context.isMobile
                  ? mobileHeight
                  : (context.isTablet ? 320 : 300),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollStartNotification &&
                          notification.dragDetails != null) {
                        _isInteracting = true;
                        _moveRequest++;
                        _isMoving = false;
                        _autoTimer?.cancel();
                      } else if (notification is ScrollEndNotification &&
                          _isInteracting) {
                        _isInteracting = false;
                        _targetPage =
                            (_controller.page ?? _currentPage.toDouble())
                                .round();
                        _scheduleAuto();
                      }
                      return false;
                    },
                    child: PageView.builder(
                      controller: _controller,
                      padEnds: true,
                      itemCount: widget.items.length < 2
                          ? widget.items.length
                          : null,
                      onPageChanged: (index) => setState(() {
                        _currentPage = index;
                        _activeIndex = _realIndexFor(index);
                      }),
                      itemBuilder: (context, index) {
                        final item = widget.items[_realIndexFor(index)];
                        return AnimatedBuilder(
                          animation: _controller,
                          child: HeroBannerImage(
                            item: item,
                            onPressed: () => widget.onBannerPressed?.call(item),
                          ),
                          builder: (context, child) {
                            final page = _controller.hasClients
                                ? (_controller.page ?? _currentPage.toDouble())
                                : _currentPage.toDouble();
                            final focus =
                                1 - (page - index).abs().clamp(0.0, 1.0);
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.md / 2,
                                vertical: AppSpacing.xs * (1 - focus),
                              ),
                              child: HeroBannerCard(
                                item: item,
                                focus: focus,
                                child: child!,
                                onPressed: () =>
                                    widget.onBannerPressed?.call(item),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: context.isMobile ? AppSpacing.xs : -12,
                    child: HeroBannerCircleControl(
                      icon: Icons.chevron_left,
                      onTap: () => _moveBy(-1),
                    ),
                  ),
                  Positioned(
                    right: context.isMobile ? AppSpacing.xs : AppSpacing.lg,
                    child: HeroBannerCircleControl(
                      icon: Icons.chevron_right,
                      onTap: () => _moveBy(1),
                    ),
                  ),
                  Positioned(
                    bottom: AppSpacing.md,
                    child: Semantics(
                      liveRegion: true,
                      label: '배너 ${_activeIndex + 1}/${widget.items.length}',
                      child: HeroBannerProgress(
                        itemCount: widget.items.length,
                        activeIndex: _activeIndex,
                        isPaused: _isPaused || _reduceMotion,
                        reducedMotion: _reduceMotion,
                        onPauseToggle: () {
                          setState(() => _isPaused = !_isPaused);
                          _scheduleAuto();
                        },
                      ),
                    ),
                  ),
                  if (!context.isMobile) ...[
                    const Positioned.fill(
                      child: IgnorePointer(
                        child: HeroBannerEdgeFade(isLeft: true),
                      ),
                    ),
                    const Positioned.fill(
                      child: IgnorePointer(
                        child: HeroBannerEdgeFade(isLeft: false),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _moveBy(int delta) {
    if (!_controller.hasClients || widget.items.length < 2) return;
    _autoTimer?.cancel();
    final current = _isMoving
        ? _targetPage
        : (_controller.page ?? _currentPage.toDouble()).round();
    final next = current + delta;
    if (next < 0) return;
    _targetPage = next;
    final request = ++_moveRequest;
    _isMoving = true;
    if (_reduceMotion) {
      _controller.jumpToPage(next);
      _isMoving = false;
      _scheduleAuto();
      return;
    }
    _controller
        .animateToPage(
          next,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeInOutCubic,
        )
        .whenComplete(() {
          if (!mounted || request != _moveRequest) return;
          _isMoving = false;
          _scheduleAuto();
        });
  }

  void _scheduleAuto() {
    _autoTimer?.cancel();
    if (!_ticksEnabled ||
        _outerScroll?.isScrollingNotifier.value == true ||
        !_isVisible ||
        _isPaused ||
        _reduceMotion ||
        _hovered ||
        _isInteracting ||
        _isMoving ||
        widget.items.length < 2) {
      return;
    }
    _autoTimer = Timer(const Duration(seconds: 5), () {
      if (mounted &&
          _ticksEnabled &&
          _outerScroll?.isScrollingNotifier.value != true &&
          _isVisible) {
        _moveBy(1);
      }
    });
  }

  int _initialPageFor(int itemCount) => itemCount < 2 ? 0 : itemCount * 1000;
  int _realIndexFor(int page) =>
      widget.items.isEmpty ? 0 : page % widget.items.length;

  @override
  void dispose() {
    _moveRequest++;
    _autoTimer?.cancel();
    _outerScroll?.isScrollingNotifier.removeListener(_onOuterScrollActivity);
    _controller.dispose();
    super.dispose();
  }
}
