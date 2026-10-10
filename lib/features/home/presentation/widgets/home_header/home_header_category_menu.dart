// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/category/domain/entities/product_category.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/widgets/home_header/home_header_category_navigation.dart';

class HomeHeaderCategoryMenuButton extends StatefulWidget {
  const HomeHeaderCategoryMenuButton({
    required this.products,
    required this.onCategorySelected,
  });

  final List<HomeProductData> products;
  final ValueChanged<String> onCategorySelected;

  @override
  State<HomeHeaderCategoryMenuButton> createState() =>
      HomeHeaderCategoryMenuButtonState();
}

class HomeHeaderCategoryMenuButtonState
    extends State<HomeHeaderCategoryMenuButton>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  ScrollPosition? _scrollPosition;
  late final AnimationController _controller;
  late final Animation<double> _revealAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      reverseDuration: const Duration(milliseconds: 120),
    );
    final revealCurve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _revealAnim = revealCurve;
    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.72, curve: Curves.easeOut),
      reverseCurve: Curves.easeIn,
    );
    _scaleAnim = Tween<double>(begin: 0.985, end: 1).animate(revealCurve);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final nextPosition = Scrollable.maybeOf(context)?.position;
    if (_scrollPosition == nextPosition) return;

    _scrollPosition?.isScrollingNotifier.removeListener(_handleScrollActivity);
    _scrollPosition = nextPosition;
    _scrollPosition?.isScrollingNotifier.addListener(_handleScrollActivity);
  }

  @override
  void dispose() {
    _scrollPosition?.isScrollingNotifier.removeListener(_handleScrollActivity);
    _controller.dispose();
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _handleScrollActivity() {
    if (_scrollPosition?.isScrollingNotifier.value ?? false) {
      _closeMenu(animate: false);
    }
  }

  void _toggleMenu() {
    if (_overlayEntry == null) {
      _openMenu();
    } else {
      _closeMenu();
    }
  }

  void _openMenu() {
    if (_overlayEntry != null) return;

    final overlay = Overlay.of(context);
    final buttonBox = context.findRenderObject() as RenderBox?;
    final overlayBox = overlay.context.findRenderObject() as RenderBox?;
    if (buttonBox == null || overlayBox == null) return;

    final buttonOffset = buttonBox.localToGlobal(
      Offset.zero,
      ancestor: overlayBox,
    );
    final overlayWidth = overlayBox.size.width;
    final panelTop = buttonOffset.dy + buttonBox.size.height + 1;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _closeMenu,
                child: const SizedBox.expand(),
              ),
            ),
            Positioned(
              left: 0,
              top: panelTop,
              width: overlayWidth,
              child: AnimatedBuilder(
                animation: _revealAnim,
                builder: (context, child) {
                  return ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: _revealAnim.value,
                      child: child,
                    ),
                  );
                },
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: ScaleTransition(
                    scale: _scaleAnim,
                    alignment: Alignment.topCenter,
                    child: HomeHeaderCategoryMegaMenuPanel(
                      products: widget.products,
                      onCategorySelected: (label) {
                        widget.onCategorySelected(label);
                        _closeMenu();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    overlay.insert(_overlayEntry!);
    _controller.forward(from: 0);
    setState(() {});
  }

  void _closeMenu({bool animate = true}) {
    if (_overlayEntry == null) return;

    if (!animate) {
      _controller.stop();
      _overlayEntry?.remove();
      _overlayEntry = null;
      if (mounted) setState(() {});
      return;
    }

    _controller.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: _toggleMenu,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.menu, color: AppColors.textPrimary, size: 22),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '카테고리',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeHeaderCategoryMegaMenuPanel extends StatefulWidget {
  const HomeHeaderCategoryMegaMenuPanel({
    required this.products,
    required this.onCategorySelected,
  });

  final List<HomeProductData> products;
  final ValueChanged<String> onCategorySelected;

  @override
  State<HomeHeaderCategoryMegaMenuPanel> createState() =>
      HomeHeaderCategoryMegaMenuPanelState();
}

class HomeHeaderCategoryMegaMenuPanelState
    extends State<HomeHeaderCategoryMegaMenuPanel> {
  ProductCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.border),
            bottom: BorderSide(color: AppColors.border),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: SizedBox(
            height: 480,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HomeHeaderCategorySideNav(
                  selectedCategory: _selectedCategory,
                  onAllPressed: () => setState(() => _selectedCategory = null),
                  onCategoryPressed: (category) {
                    setState(() => _selectedCategory = category);
                  },
                ),
                const VerticalDivider(width: 1, color: AppColors.border),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 28, 32, 24),
                    child: _selectedCategory == null
                        ? HomeHeaderAllCategoryOverview(
                            products: widget.products,
                            onCategorySelected: widget.onCategorySelected,
                          )
                        : HomeHeaderSelectedCategoryView(
                            category: _selectedCategory!,
                            onCategorySelected: widget.onCategorySelected,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
