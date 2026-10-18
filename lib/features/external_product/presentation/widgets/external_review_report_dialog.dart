import 'package:go_router/go_router.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/external_actions_view_model.dart';
import 'package:re_view_front/features/external_product/presentation/widgets/external_action_notice.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

class ExternalReviewReportDialog extends ConsumerStatefulWidget {
  const ExternalReviewReportDialog({
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
  ConsumerState<ExternalReviewReportDialog> createState() => _ReportState();
}

class _ReportState extends ConsumerState<ExternalReviewReportDialog> {
  final _form = GlobalKey<FormState>();
  final _detail = TextEditingController();
  final _attachment = TextEditingController();
  String _reason = 'FAKE_REVIEW';
  bool _evidence = false;
  @override
  void dispose() {
    _detail.dispose();
    _attachment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final provider = externalReviewActionsProvider((
      product: widget.product,
      reviewId: widget.reviewId,
    ));
    final busy = ref.watch(provider);
    final reasons = {
      'FAKE_REVIEW': l.externalReasonFake,
      'AI_GENERATED': l.externalReasonAi,
      'IRRELEVANT_CONTENT': l.externalReasonIrrelevant,
      'INAPPROPRIATE': l.externalReasonInappropriate,
      'AD_REVIEW': l.externalReasonAd,
      'REPETITIVE_CONTENT': l.externalReasonRepeated,
      'OFFENSIVE_CONTENT': l.externalReasonOffensive,
      'OTHER': l.externalReasonOther,
    };
    return PopScope(
      canPop: !busy,
      child: AlertDialog(
        title: Text(l.externalReport),
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Form(
              key: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.productName != null) Text(widget.productName!),
                  if (widget.reviewContent != null)
                    Text(
                      widget.reviewContent!,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _reason,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: l.externalReason),
                    items: reasons.entries
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.key,
                            child: Text(
                              e.value,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: busy
                        ? null
                        : (v) => setState(() => _reason = v!),
                  ),
                  TextFormField(
                    controller: _detail,
                    enabled: !busy,
                    minLines: 3,
                    maxLines: 5,
                    maxLength: 500,
                    decoration: InputDecoration(labelText: l.externalDetail),
                    validator: (v) => (v?.trim().length ?? 0) < 20
                        ? l.externalDetailValidation
                        : null,
                  ),
                  TextFormField(
                    controller: _attachment,
                    enabled: !busy,
                    maxLength: 1000,
                    decoration: InputDecoration(
                      labelText: l.externalAttachment,
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return null;
                      final uri = Uri.tryParse(v.trim());
                      return uri != null &&
                              uri.hasAuthority &&
                              (uri.scheme == 'https' || uri.scheme == 'http')
                          ? null
                          : l.externalAttachmentValidation;
                    },
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.externalEvidence),
                    value: _evidence,
                    onChanged: busy
                        ? null
                        : (v) => setState(() => _evidence = v!),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: busy ? null : () => Navigator.pop(context),
            child: Text(l.externalCancel),
          ),
          FilledButton(
            onPressed: busy
                ? null
                : () async {
                    if (!_form.currentState!.validate()) return;
                    final result = await ref
                        .read(provider.notifier)
                        .submit(
                          reason: _reason,
                          detail: _detail.text.trim(),
                          includeAiEvidence: _evidence,
                          attachmentUrl: _attachment.text.trim().isEmpty
                              ? null
                              : _attachment.text.trim(),
                        );
                    if (!context.mounted) return;
                    if (!ref.read(isLoggedInProvider)) {
                      context.go(
                        '/login?from=${Uri.encodeComponent(widget.product.routePath)}',
                      );
                      return;
                    }
                    if (result == null) return;
                    final messenger = ScaffoldMessenger.of(context);
                    if (result is Success<void>) {
                      Navigator.pop(context);
                      messenger.showSnackBar(
                        SnackBar(content: Text(l.externalSuccess)),
                      );
                    } else {
                      showExternalActionResult(context, widget.product, result);
                    }
                  },
            child: Text(l.externalSubmit),
          ),
        ],
      ),
    );
  }
}
