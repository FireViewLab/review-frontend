import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/section_card.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/trendy_dropdown.dart';

class DetailInputSection extends StatefulWidget {
  const DetailInputSection({
    super.key,
    required this.controller,
    required this.reportType,
    required this.disclosure,
    required this.onReportTypeChanged,
    required this.onDisclosureChanged,
    required this.attachments,
    required this.onAttachmentsChanged,
  });

  final TextEditingController controller;
  final String? reportType;
  final String? disclosure;
  final ValueChanged<String?> onReportTypeChanged;
  final ValueChanged<String?> onDisclosureChanged;
  final List<PlatformFile> attachments;
  final ValueChanged<List<PlatformFile>> onAttachmentsChanged;

  @override
  State<DetailInputSection> createState() => _DetailInputSectionState();
}

class _DetailInputSectionState extends State<DetailInputSection> {
  static const _maxFiles = 4;
  static const _maxBytes = 10 * 1024 * 1024;

  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _charCount = widget.controller.text.trim().length;
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    setState(() => _charCount = widget.controller.text.trim().length);
  }

  Future<void> _pickFiles() async {
    final remaining = _maxFiles - widget.attachments.length;
    if (remaining <= 0) {
      _showSnack('최대 $_maxFiles개까지만 첨부할 수 있어요.');
      return;
    }

    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['png', 'jpg', 'jpeg', 'pdf'],
      allowMultiple: true,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    final added = <PlatformFile>[];
    for (final f in result.files) {
      if (added.length + widget.attachments.length >= _maxFiles) break;
      if (f.size > _maxBytes) {
        _showSnack('${f.name}은 10MB를 초과합니다.');
        continue;
      }
      final exists = widget.attachments.any(
        (e) => e.name == f.name && e.size == f.size,
      );
      if (!exists) added.add(f);
    }
    if (added.isEmpty) return;
    widget.onAttachmentsChanged([...widget.attachments, ...added]);
  }

  void _removeFile(int index) {
    final next = [...widget.attachments];
    next.removeAt(index);
    widget.onAttachmentsChanged(next);
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final isEnough = _charCount >= 20;
    final canAddMore = widget.attachments.length < _maxFiles;

    return SectionCard(
      title: '상세 근거 입력',
      description: '신고 판단에 도움이 되는 내용을 남겨주세요.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TrendyDropdown(
                  label: '신고 유형',
                  value: widget.reportType,
                  items: const ['반복 문구', '계정 생성 직후', '유사 리뷰 군집', '기타'],
                  onChanged: widget.onReportTypeChanged,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TrendyDropdown(
                  label: '처리 결과 공개 범위',
                  value: widget.disclosure,
                  items: const ['비공개', '나에게만 공개', '운영팀 공유'],
                  onChanged: widget.onDisclosureChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '상세 설명',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            controller: widget.controller,
            maxLines: 5,
            validator: (v) {
              if (v == null || v.trim().length < 20) {
                return '최소 20자 이상 입력해주세요.';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: '구체적인 문제 내용과 맥락을 입력해주세요.',
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textTertiary,
              ),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: Text(
                  isEnough
                      ? '최소 20자 이상 입력하면 운영팀 검토에 더 도움이 돼요.'
                      : '최소 20자 이상 입력해주세요.',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isEnough
                        ? AppColors.textTertiary
                        : AppColors.error,
                  ),
                ),
              ),
              Text(
                '$_charCount자',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isEnough
                      ? AppColors.primary
                      : AppColors.textTertiary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Text(
                '첨부 자료 ',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '(선택)',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const Spacer(),
              Text(
                '${widget.attachments.length} / $_maxFiles',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          _AttachmentBox(onAttach: canAddMore ? _pickFiles : null),
          if (widget.attachments.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Column(
              children: [
                for (var i = 0; i < widget.attachments.length; i++)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: i == widget.attachments.length - 1
                          ? 0
                          : AppSpacing.xs,
                    ),
                    child: _AttachmentRow(
                      file: widget.attachments[i],
                      onRemove: () => _removeFile(i),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _AttachmentBox extends StatelessWidget {
  const _AttachmentBox({this.onAttach});

  final VoidCallback? onAttach;

  @override
  Widget build(BuildContext context) {
    final disabled = onAttach == null;
    return InkWell(
      onTap: onAttach,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(
                Icons.upload_outlined,
                size: 18,
                color: disabled
                    ? AppColors.textTertiary
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    disabled
                        ? '첨부 가능한 개수를 모두 채웠어요'
                        : '스크린샷이나 추가 근거를 첨부해주세요',
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: disabled
                          ? AppColors.textTertiary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'PNG, JPG, PDF · 최대 10MB · 최대 4개',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            OutlinedButton(
              onPressed: onAttach,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.borderStrong),
                foregroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                '파일 선택',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentRow extends StatelessWidget {
  const _AttachmentRow({required this.file, required this.onRemove});

  final PlatformFile file;
  final VoidCallback onRemove;

  static String _formatSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(0)}KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)}MB';
  }

  IconData get _icon {
    final ext = file.extension?.toLowerCase();
    if (ext == 'pdf') return Icons.picture_as_pdf_outlined;
    return Icons.image_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(_icon, size: 18, color: AppColors.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                Text(
                  _formatSize(file.size),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close, size: 16),
            color: AppColors.textTertiary,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
          ),
        ],
      ),
    );
  }
}
