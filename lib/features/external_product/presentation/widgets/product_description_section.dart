import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';
import 'package:re_view_front/shared/widgets/image_preview_dialog.dart';

class ProductDescriptionSection extends StatefulWidget {
  const ProductDescriptionSection({required this.product, super.key});

  final ExternalProduct product;

  @override
  State<ProductDescriptionSection> createState() =>
      _ProductDescriptionSectionState();
}

class _ProductDescriptionSectionState extends State<ProductDescriptionSection> {
  bool _expanded = false;
  final _headingKey = GlobalKey();

  void _toggle() {
    final collapsing = _expanded;
    setState(() => _expanded = !_expanded);
    if (!collapsing) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final heading = _headingKey.currentContext;
      if (heading != null) {
        Scrollable.ensureVisible(heading, alignment: .02);
      }
    });
  }

  @override
  void didUpdateWidget(ProductDescriptionSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product.ref != widget.product.ref) _expanded = false;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    if (!product.hasDescription) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final description = product.description?.trim();
    final images = product.detailImages;
    final visibleImageCount = _expanded
        ? images.length
        : (images.isEmpty ? 0 : 1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          key: _headingKey,
          header: true,
          child: Text(
            l10n.extDescriptionTitle,
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.extDescriptionSource,
          style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        if (description != null && description.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            description,
            maxLines: _expanded ? null : 6,
            overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
        ],
        for (var index = 0; index < visibleImageCount; index++)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            child: _DescriptionImage(
              key: ValueKey(images[index]),
              images: images,
              index: index,
              collapsed: !_expanded,
            ),
          ),
        const SizedBox(height: AppSpacing.md),
        Semantics(
          expanded: _expanded,
          child: OutlinedButton.icon(
            onPressed: _toggle,
            icon: Icon(
              _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
            ),
            label: Text(
              _expanded
                  ? l10n.extDescriptionCollapse
                  : l10n.extDescriptionExpand,
            ),
          ),
        ),
      ],
    );
  }
}

class _DescriptionImage extends StatelessWidget {
  const _DescriptionImage({
    required this.images,
    required this.index,
    required this.collapsed,
    super.key,
  });

  final List<String> images;
  final int index;
  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    void open() => showImagePreviewDialog(
      context,
      imageUrls: images,
      initialIndex: index,
      title: l10n.extDescriptionTitle,
    );
    return Semantics(
      image: true,
      button: true,
      label: l10n.extDescriptionImage(index + 1),
      onTap: open,
      excludeSemantics: true,
      child: Material(
        color: AppColors.surfaceMuted,
        child: InkWell(
          onTap: open,
          child: ClipRect(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: collapsed ? 480 : double.infinity,
              ),
              child: AppNetworkImage(
                url: images[index],
                intrinsicHeight: true,
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
                placeholderIcon: Icons.broken_image_outlined,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
