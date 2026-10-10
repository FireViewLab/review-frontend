import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

/// 필터 컨트롤 공통 래퍼: 라벨(상단) + 입력 컨트롤(하단).
class AdminLabeledField extends StatelessWidget {
  const AdminLabeledField({
    super.key,
    required this.label,
    required this.child,
    this.width,
  });

  final String label;
  final Widget child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        child,
      ],
    );
    return width == null ? content : SizedBox(width: width, child: content);
  }
}

class AdminDropdownItem<T> {
  const AdminDropdownItem({required this.value, required this.label});

  final T value;
  final String label;
}

/// 라벨이 달린 드롭다운 필터.
class AdminDropdownField<T> extends StatelessWidget {
  const AdminDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.width = 160,
  });

  final String label;
  final T value;
  final List<AdminDropdownItem<T>> items;
  final ValueChanged<T?> onChanged;
  final double width;

  @override
  Widget build(BuildContext context) {
    return AdminLabeledField(
      label: label,
      width: width,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: AppColors.border),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            isDense: true,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: AppColors.textSecondary,
            ),
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            items: [
              for (final item in items)
                DropdownMenuItem<T>(
                  value: item.value,
                  child: Text(item.label, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

/// 라벨이 달린 검색 입력 필터.
class AdminSearchField extends StatelessWidget {
  const AdminSearchField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.width = 260,
  });

  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final double width;

  @override
  Widget build(BuildContext context) {
    return AdminLabeledField(
      label: label,
      width: width,
      child: SizedBox(
        height: 40,
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 13,
              color: AppColors.textTertiary,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              size: 18,
              color: AppColors.textSecondary,
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 36),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            filled: true,
            fillColor: AppColors.surface,
            border: _border(AppColors.border),
            enabledBorder: _border(AppColors.border),
            focusedBorder: _border(AppColors.primary),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: BorderSide(color: color),
      );
}
