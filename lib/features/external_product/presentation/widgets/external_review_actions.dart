import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/external_actions_view_model.dart';
import 'package:re_view_front/features/external_product/presentation/widgets/external_action_notice.dart';
import 'package:re_view_front/features/external_product/presentation/widgets/external_review_report_dialog.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

class ExternalReviewActions extends StatelessWidget {
  const ExternalReviewActions({
    super.key,
    required this.product,
    required this.reviewId,
    this.productName,
    this.reviewContent,
  });
  final ExternalProductRef product;
  final String reviewId;
  final String? productName, reviewContent;
  @override
  Widget build(BuildContext context) => _ExternalReviewActions(
    key: ValueKey((product, reviewId)),
    product: product,
    reviewId: reviewId,
    productName: productName,
    reviewContent: reviewContent,
  );
}

class _ExternalReviewActions extends ConsumerWidget {
  const _ExternalReviewActions({
    super.key,
    required this.product,
    required this.reviewId,
    this.productName,
    this.reviewContent,
  });
  final ExternalProductRef product;
  final String reviewId;
  final String? productName, reviewContent;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = externalReviewActionsProvider((
      product: product,
      reviewId: reviewId,
    ));
    final busy = ref.watch(provider);
    final l = AppLocalizations.of(context);
    return PopupMenuButton<String>(
      tooltip: l.externalReviewMenu,
      enabled: !busy,
      icon: const Icon(Icons.more_horiz, size: 20),
      itemBuilder: (_) => [
        PopupMenuItem(value: 'REPORT', child: Text(l.externalReport)),
        PopupMenuItem(value: 'REAL', child: Text(l.externalReal)),
        PopupMenuItem(value: 'FAKE', child: Text(l.externalFake)),
      ],
      onSelected: (type) async {
        if (!ref.read(isLoggedInProvider)) {
          context.go('/login?from=${Uri.encodeComponent(product.routePath)}');
          return;
        }
        if (type == 'REPORT') {
          await showDialog<void>(
            context: context,
            builder: (_) => ExternalReviewReportDialog(
              product: product,
              reviewId: reviewId,
              productName: productName,
              reviewContent: reviewContent,
            ),
          );
          return;
        }
        final result = await ref
            .read(provider.notifier)
            .submit(feedbackType: type);
        if (!context.mounted || !ref.exists(provider)) return;
        if (!ref.read(isLoggedInProvider)) {
          context.go('/login?from=${Uri.encodeComponent(product.routePath)}');
          return;
        }
        showExternalActionResult(context, product, result);
      },
    );
  }
}
