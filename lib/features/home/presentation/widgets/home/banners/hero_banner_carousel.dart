import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';

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
                          child: _BannerImage(
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
                              child: _BannerCard(
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
                    child: _CircleControl(
                      icon: Icons.chevron_left,
                      onTap: () => _moveBy(-1),
                    ),
                  ),
                  Positioned(
                    right: context.isMobile ? AppSpacing.xs : AppSpacing.lg,
                    child: _CircleControl(
                      icon: Icons.chevron_right,
                      onTap: () => _moveBy(1),
                    ),
                  ),
                  Positioned(
                    bottom: AppSpacing.md,
                    child: Semantics(
                      liveRegion: true,
                      label: '배너 ${_activeIndex + 1}/${widget.items.length}',
                      child: _BannerProgress(
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
                        child: _CarouselEdgeFade(isLeft: true),
                      ),
                    ),
                    const Positioned.fill(
                      child: IgnorePointer(
                        child: _CarouselEdgeFade(isLeft: false),
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

class _CarouselEdgeFade extends StatelessWidget {
  const _CarouselEdgeFade({required this.isLeft});

  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: isLeft ? Alignment.centerLeft : Alignment.centerRight,
            end: isLeft ? Alignment.centerRight : Alignment.centerLeft,
            colors: const [AppColors.background, Color(0x00F8FAFC)],
          ),
        ),
      ),
    );
  }
}

class _BannerProgress extends StatelessWidget {
  const _BannerProgress({
    required this.itemCount,
    required this.activeIndex,
    required this.isPaused,
    required this.reducedMotion,
    required this.onPauseToggle,
  });

  final int itemCount;
  final int activeIndex;
  final bool isPaused;
  final bool reducedMotion;
  final VoidCallback onPauseToggle;

  @override
  Widget build(BuildContext context) {
    // Keep the original slim pill while retaining a larger pause hit target.
    return SizedBox(
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            top: 6,
            bottom: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.34),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x140F172A),
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (itemCount > 8)
                  Text('${activeIndex + 1}/$itemCount')
                else
                  for (var i = 0; i < itemCount; i++)
                    Container(
                      width: i == activeIndex ? 28 : 7,
                      height: 6,
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        color: i == activeIndex
                            ? AppColors.textPrimary.withValues(alpha: 0.92)
                            : Colors.white.withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                const SizedBox(width: AppSpacing.xxs),
                const SizedBox.square(dimension: 24),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 48,
            child: IconButton(
              tooltip: isPaused ? '재생' : '일시정지',
              onPressed: reducedMotion ? null : onPauseToggle,
              icon: Icon(
                isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                size: 16,
              ),
              color: AppColors.textPrimary.withValues(alpha: 0.9),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({
    required this.item,
    required this.focus,
    required this.child,
    required this.onPressed,
  });

  final HomeBannerData item;
  final double focus;
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${item.title} ${item.emphasis}',
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0x160F172A,
                ).withValues(alpha: 0x16 / 255 * focus),
                blurRadius: 24,
                offset: Offset(0, 16),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _BannerImage extends StatelessWidget {
  const _BannerImage({required this.item, required this.onPressed});
  final HomeBannerData item;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final useCompactText = context.viewportSize.width < 1280;
    return item.imageUrl != null
        ? AppNetworkImage(
            url: context.isMobile
                ? item.mobileImageUrl ?? item.imageUrl!
                : item.imageUrl!,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            placeholderIcon: Icons.image_not_supported_outlined,
          )
        : Image.asset(
            item.assetPath!,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) => context.isMobile
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: Center(
                      child: Text(
                        '${item.title}\n${item.emphasis}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(38),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 11,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.title,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                item.emphasis,
                                style:
                                    (context.isMobile || useCompactText
                                            ? Theme.of(
                                                context,
                                              ).textTheme.headlineSmall
                                            : Theme.of(
                                                context,
                                              ).textTheme.displayMedium)
                                        ?.copyWith(
                                          color: item.accentColor,
                                          fontWeight: FontWeight.w900,
                                        ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                item.description,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              OutlinedButton(
                                onPressed: onPressed,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(item.ctaLabel),
                                    const SizedBox(width: AppSpacing.xxs),
                                    const Icon(Icons.chevron_right, size: 18),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!context.isMobile) ...[
                          const SizedBox(width: AppSpacing.md),
                          Expanded(flex: 8, child: _BannerVisual(item: item)),
                        ],
                      ],
                    ),
                  ),
          );
  }
}

class _BannerVisual extends StatelessWidget {
  const _BannerVisual({required this.item});

  final HomeBannerData item;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 172,
          height: 172,
          decoration: const BoxDecoration(
            color: Color(0xB3FFFFFF),
            shape: BoxShape.circle,
          ),
        ),
        Icon(item.icon, size: 118, color: item.accentColor.withAlpha(210)),
        Positioned(
          top: AppSpacing.sm,
          right: 0,
          child: Container(
            width: 104,
            height: 104,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x120F172A),
                  blurRadius: 18,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Text(
              '${item.badgeLabel}\n신뢰도 확인',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CircleControl extends StatelessWidget {
  const _CircleControl({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: const Color(0x1A0F172A),
      child: IconButton(
        tooltip: icon == Icons.chevron_left ? '이전 배너' : '다음 배너',
        onPressed: onTap,
        icon: Icon(icon, color: AppColors.textPrimary),
      ),
    );
  }
}
