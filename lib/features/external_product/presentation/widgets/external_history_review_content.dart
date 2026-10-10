import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_history_target.dart';

class ExternalHistoryReviewContent extends StatelessWidget {
  const ExternalHistoryReviewContent({
    super.key,
    required this.reviewContent,
    required this.productName,
    this.productExternalId,
    this.style,
    this.maxLines,
  });
  final String? reviewContent, productExternalId;
  final String productName;
  final TextStyle? style;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    final target = externalHistoryTarget(productExternalId);
    return InkWell(
      onTap: target == null ? null : () => context.go(target.routePath),
      child: Text(
        reviewContent ?? productName,
        style: style,
        maxLines: maxLines,
        overflow: maxLines == null ? null : TextOverflow.ellipsis,
      ),
    );
  }
}
