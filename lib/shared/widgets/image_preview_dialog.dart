import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';

Future<void> showImagePreviewDialog(
  BuildContext context, {
  required List<String> imageUrls,
  int initialIndex = 0,
  String? title,
  String? previousLabel,
  String? nextLabel,
}) async {
  final images = imageUrls
      .map((url) => url.trim())
      .where((url) => url.isNotEmpty)
      .toList(growable: false);
  if (images.isEmpty) return;
  final requested = initialIndex.clamp(0, imageUrls.length);
  final selected = imageUrls
      .take(requested)
      .where((url) => url.trim().isNotEmpty)
      .length
      .clamp(0, images.length - 1);
  await showDialog<void>(
    context: context,
    useRootNavigator: true,
    animationStyle: MediaQuery.disableAnimationsOf(context)
        ? AnimationStyle.noAnimation
        : null,
    builder: (_) => _ImagePreviewDialog(
      imageUrls: images,
      initialIndex: selected,
      title: title,
      previousLabel: previousLabel,
      nextLabel: nextLabel,
    ),
  );
}

class ImagePreviewThumbnail extends StatelessWidget {
  const ImagePreviewThumbnail({
    super.key,
    required this.imageUrls,
    required this.index,
    this.size = 80,
    this.child,
  });

  final List<String> imageUrls;
  final int index;
  final double size;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (index < 0 || index >= imageUrls.length) return const SizedBox.shrink();
    final label =
        '${AppLocalizations.of(context).imagePreviewOpen} ${index + 1}/${imageUrls.length}';
    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        label: label,
        child: SizedBox.square(
          dimension: size,
          child: ClipRRect(
            borderRadius: AppRadius.small,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ExcludeSemantics(
                  child: child ?? AppNetworkImage(url: imageUrls[index]),
                ),
                Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () => showImagePreviewDialog(
                      context,
                      imageUrls: imageUrls,
                      initialIndex: index,
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

class _ImagePreviewDialog extends StatefulWidget {
  const _ImagePreviewDialog({
    required this.imageUrls,
    required this.initialIndex,
    this.title,
    this.previousLabel,
    this.nextLabel,
  });

  final List<String> imageUrls;
  final int initialIndex;
  final String? title;
  final String? previousLabel;
  final String? nextLabel;

  @override
  State<_ImagePreviewDialog> createState() => _ImagePreviewDialogState();
}

class _ImagePreviewDialogState extends State<_ImagePreviewDialog> {
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
  }

  void _move(int direction) {
    final next = _current + direction;
    if (next >= 0 && next < widget.imageUrls.length) {
      setState(() => _current = next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.imageUrls;
    final l10n = AppLocalizations.of(context);
    final title = widget.title ?? l10n.imagePreviewTitle;
    void close() => Navigator.of(context).pop();
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): close,
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () => _move(-1),
        const SingleActivator(LogicalKeyboardKey.arrowRight): () => _move(1),
      },
      child: Focus(
        autofocus: true,
        child: Dialog(
          backgroundColor: AppColors.surface,
          insetPadding: const EdgeInsets.all(AppSpacing.md),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 680,
              maxHeight: MediaQuery.sizeOf(context).height * .85,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        tooltip: MaterialLocalizations.of(
                          context,
                        ).closeButtonTooltip,
                        onPressed: close,
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Semantics(
                      image: true,
                      label: '$title ${_current + 1}/${images.length}',
                      child: InteractiveViewer(
                        key: ValueKey(_current),
                        minScale: 1,
                        maxScale: 4,
                        child: AppNetworkImage(
                          url: images[_current],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (images.length > 1)
                      IconButton(
                        tooltip:
                            widget.previousLabel ?? l10n.imagePreviewPrevious,
                        onPressed: _current > 0 ? () => _move(-1) : null,
                        icon: const Icon(Icons.chevron_left),
                      ),
                    Semantics(
                      liveRegion: true,
                      child: Text('${_current + 1} / ${images.length}'),
                    ),
                    if (images.length > 1)
                      IconButton(
                        tooltip: widget.nextLabel ?? l10n.imagePreviewNext,
                        onPressed: _current < images.length - 1
                            ? () => _move(1)
                            : null,
                        icon: const Icon(Icons.chevron_right),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
