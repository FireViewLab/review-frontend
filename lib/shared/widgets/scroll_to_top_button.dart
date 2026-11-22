import 'package:flutter/material.dart';
import 'package:re_view_front/app/responsive/breakpoints.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_motion.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

/// Scaffold의 floatingActionButton 영역에서 채팅 런처 위에 배치한다.
class ScrollToTopButton extends StatefulWidget {
  const ScrollToTopButton({
    required this.controller,
    this.besideChat = false,
    super.key,
  });

  final ScrollController controller;
  final bool besideChat;

  @override
  State<ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton> {
  bool _visible = false;
  double _threshold = double.infinity;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateVisibility);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _threshold = MediaQuery.sizeOf(context).height * 1.5;
    _checkAfterLayout();
  }

  @override
  void didUpdateWidget(ScrollToTopButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_updateVisibility);
      widget.controller.addListener(_updateVisibility);
    }
    _checkAfterLayout();
  }

  void _checkAfterLayout() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateVisibility();
    });
  }

  void _updateVisibility() {
    final positions = widget.controller.positions;
    final visible =
        positions.length == 1 &&
        positions.single.hasContentDimensions &&
        positions.single.pixels - positions.single.minScrollExtent >=
            _threshold;
    if (_visible != visible) setState(() => _visible = visible);
  }

  Future<void> _scrollToTop() async {
    final positions = widget.controller.positions;
    if (positions.length != 1) return;
    final top = positions.single.minScrollExtent;
    if (MediaQuery.disableAnimationsOf(context)) {
      widget.controller.jumpTo(top);
    } else {
      await widget.controller.animateTo(
        top,
        duration: AppMotion.slow,
        curve: AppMotion.enter,
      );
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateVisibility);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = AppLocalizations.of(context).scrollToTop;
    final extraEdge = AppBreakpoints.isMobile(MediaQuery.sizeOf(context).width)
        ? 0.0
        : AppSpacing.lg - AppSpacing.md;
    // Scaffold가 하단 탭과 safe area를 피한다. 런처 높이 52px와 간격을 더한다.
    return Padding(
      padding: EdgeInsets.only(
        right: extraEdge + (widget.besideChat ? 52 + AppSpacing.md : 0),
        bottom: extraEdge + (widget.besideChat ? 0 : 52 + AppSpacing.md),
      ),
      child: IgnorePointer(
        ignoring: !_visible,
        child: ExcludeFocus(
          excluding: !_visible,
          child: ExcludeSemantics(
            excluding: !_visible,
            child: AnimatedOpacity(
              opacity: _visible ? 1 : 0,
              duration: AppMotion.of(
                context,
                _visible ? AppMotion.base : AppMotion.fast,
              ),
              curve: _visible ? AppMotion.enter : AppMotion.exit,
              child: Material(
                color: AppColors.surface,
                shadowColor: Theme.of(context).shadowColor,
                elevation: 4,
                shape: const CircleBorder(
                  side: BorderSide(color: AppColors.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: IconButton(
                  onPressed: _scrollToTop,
                  tooltip: label,
                  constraints: const BoxConstraints.tightFor(
                    width: 48,
                    height: 48,
                  ),
                  icon: const Icon(
                    Icons.arrow_upward_rounded,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
