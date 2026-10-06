import 'package:re_view_front/app/theme/app_motion.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

class TrendyDropdown extends StatefulWidget {
  const TrendyDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint = '선택해주세요',
  });

  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hint;

  @override
  State<TrendyDropdown> createState() => _TrendyDropdownState();
}

class _TrendyDropdownState extends State<TrendyDropdown>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _overlay;
  late final AnimationController _controller;
  late final Animation<double> _anim;
  bool _hovering = false;

  bool get _isOpen => _overlay != null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: AppMotion.base);
    _anim = CurvedAnimation(parent: _controller, curve: AppMotion.enter);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.duration = AppMotion.of(context, AppMotion.base);
    if (MediaQuery.disableAnimationsOf(context) && _controller.isAnimating) {
      _controller.value = _isOpen ? 1 : 0;
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_isOpen) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    final renderBox =
        _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final size = renderBox.size;

    _overlay = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _close,
              ),
            ),
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 6),
                child: FadeTransition(
                  opacity: _anim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, -0.04),
                      end: Offset.zero,
                    ).animate(_anim),
                    child: _DropdownMenu(
                      items: widget.items,
                      value: widget.value,
                      onSelected: (v) {
                        widget.onChanged(v);
                        _close();
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

    Overlay.of(context).insert(_overlay!);
    _controller.forward();
    setState(() {});
  }

  Future<void> _close() async {
    if (!_isOpen) return;
    await _controller.reverse();
    _removeOverlay();
    if (mounted) setState(() {});
  }

  void _removeOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = widget.value != null && widget.value!.isNotEmpty;
    final isActive = _isOpen;
    final borderColor = isActive
        ? AppColors.primary
        : _hovering
        ? AppColors.borderStrong
        : AppColors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        CompositedTransformTarget(
          link: _layerLink,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _hovering = true),
            onExit: (_) => setState(() => _hovering = false),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _toggle,
              child: AnimatedContainer(
                key: _fieldKey,
                duration: AppMotion.of(context, AppMotion.base),
                curve: AppMotion.enter,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: borderColor,
                    width: isActive ? 1.5 : 1,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        hasValue ? widget.value! : widget.hint,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: hasValue
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: hasValue
                              ? AppColors.textPrimary
                              : AppColors.textTertiary,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      duration: AppMotion.of(context, AppMotion.base),
                      turns: isActive ? 0.5 : 0,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: isActive
                            ? AppColors.primary
                            : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownMenu extends StatelessWidget {
  const _DropdownMenu({
    required this.items,
    required this.value,
    required this.onSelected,
  });

  final List<String> items;
  final String? value;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final item in items)
              _MenuItem(
                label: item,
                selected: item == value,
                onTap: () => onSelected(item),
              ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatefulWidget {
  const _MenuItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.selected
        ? AppColors.primary.withValues(alpha: 0.08)
        : _hovering
        ? AppColors.background
        : Colors.transparent;
    final fg = widget.selected ? AppColors.primary : AppColors.textPrimary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppMotion.of(context, AppMotion.fast),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: widget.selected
                        ? FontWeight.w800
                        : FontWeight.w600,
                    color: fg,
                  ),
                ),
              ),
              if (widget.selected)
                const Icon(
                  Icons.check_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
