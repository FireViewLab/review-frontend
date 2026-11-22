import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/responsive/breakpoints.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_motion.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/features/external_product/presentation/providers/external_product_providers.dart';
import 'package:re_view_front/features/external_product/presentation/widgets/external_product_action_bar.dart';
import 'package:re_view_front/shared/presentation/bottom_action_bar_height.dart';

/// Watches the summary's actual bounds without rebuilding the detail on scroll.
class ExternalProductStickyActions extends ConsumerStatefulWidget {
  const ExternalProductStickyActions({
    super.key,
    required this.productRef,
    required this.controller,
    required this.actionsKey,
    required this.viewportKey,
  });

  final ExternalProductRef productRef;
  final ScrollController controller;
  final GlobalKey actionsKey;
  final GlobalKey viewportKey;

  @override
  ConsumerState<ExternalProductStickyActions> createState() =>
      _ExternalProductStickyActionsState();
}

class _ExternalProductStickyActionsState
    extends ConsumerState<ExternalProductStickyActions> {
  final _barKey = GlobalKey();
  bool _visible = false;
  bool _checkScheduled = false;
  bool _available = false;
  BottomActionBarHeight? _height;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_scheduleCheck);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleCheck();
  }

  @override
  void didUpdateWidget(ExternalProductStickyActions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_scheduleCheck);
      widget.controller.addListener(_scheduleCheck);
    }
    if (oldWidget.productRef != widget.productRef) {
      _clearHeight();
      _visible = false;
    }
    _scheduleCheck();
  }

  void _clearHeight() {
    final height = _height;
    WidgetsBinding.instance.addPostFrameCallback((_) => height?.update(0));
  }

  void _scheduleCheck() {
    if (_checkScheduled) return;
    _checkScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScheduled = false;
      if (!mounted) return;
      final anchor = widget.actionsKey.currentContext?.findRenderObject();
      final viewport = widget.viewportKey.currentContext?.findRenderObject();
      final mobile = AppBreakpoints.isMobile(MediaQuery.sizeOf(context).width);
      final visible =
          mobile &&
          _available &&
          anchor is RenderBox &&
          anchor.attached &&
          anchor.hasSize &&
          viewport is RenderBox &&
          viewport.attached &&
          viewport.hasSize &&
          anchor.localToGlobal(Offset(0, anchor.size.height)).dy <=
              viewport.localToGlobal(Offset.zero).dy;
      if (_visible != visible) setState(() => _visible = visible);
      final bar = _barKey.currentContext?.findRenderObject();
      if (bar is RenderBox && bar.hasSize) {
        // The global launcher already includes the system bottom inset.
        _height?.update(
          (bar.size.height - MediaQuery.paddingOf(context).bottom).clamp(
            0,
            double.infinity,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_scheduleCheck);
    _clearHeight();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = bottomActionBarHeightProvider(widget.productRef.routePath);
    ref.listen(provider, (_, _) {});
    _height = ref.read(provider.notifier);
    final selection = ref.watch(
      externalProductViewModelProvider(widget.productRef).select(
        (state) => (
          product: state.displayProduct,
          numericId: state.product == null
              ? state.displayNumericId
              : state.springProductId,
        ),
      ),
    );
    _available = selection.product != null;
    _scheduleCheck();
    final product = selection.product;
    final show =
        _visible &&
        _available &&
        AppBreakpoints.isMobile(MediaQuery.sizeOf(context).width);
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        _scheduleCheck();
        return false;
      },
      child: SizeChangedLayoutNotifier(
        key: _barKey,
        child: IgnorePointer(
          ignoring: !show,
          child: ExcludeFocus(
            excluding: !show,
            child: ExcludeSemantics(
              excluding: !show,
              child: AnimatedSwitcher(
                duration: AppMotion.of(context, AppMotion.base),
                reverseDuration: AppMotion.of(context, AppMotion.fast),
                switchInCurve: AppMotion.enter,
                switchOutCurve: AppMotion.exit,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.08),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: show && product != null
                    ? Material(
                        key: const ValueKey('product-actions'),
                        color: AppColors.surface,
                        elevation: 8,
                        child: SafeArea(
                          top: false,
                          child: SingleChildScrollView(
                            primary: false,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.xs,
                            ),
                            child: ExternalProductActionBar(
                              product: widget.productRef,
                              springProductId: selection.numericId,
                              compact: true,
                              onVisitShop: externalProductShopAction(product),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
