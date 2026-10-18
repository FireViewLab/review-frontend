import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/features/settings/presentation/widgets/settings_section_widgets.dart';

class SettingsLanguageSection extends StatelessWidget {
  const SettingsLanguageSection({
    super.key,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  static const _langs = [
    (locale: Locale('ko'), label: '한국어', sub: 'Korean'),
    (locale: Locale('en'), label: 'English', sub: 'English'),
    (locale: Locale('ja'), label: '日本語', sub: 'Japanese'),
    (locale: Locale('zh'), label: '中文', sub: 'Chinese'),
  ];

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsSectionHeader(
            icon: Icons.language_outlined,
            iconColor: const Color(0xFF059669),
            iconBg: const Color(0xFFD1FAE5),
            title: AppLocalizations.of(context).settingsLanguageSection,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppLocalizations.of(context).settingsLanguageApplyNow,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.xs,
              mainAxisSpacing: AppSpacing.xs,
              mainAxisExtent: 56,
            ),
            itemCount: _langs.length,
            itemBuilder: (context, index) {
              final lang = _langs[index];
              return SettingsLangChip(
                label: lang.label,
                sub: lang.sub,
                selected:
                    currentLocale.languageCode == lang.locale.languageCode,
                onTap: () => onLocaleChanged(lang.locale),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SettingsLangChip extends StatelessWidget {
  const SettingsLangChip({
    super.key,
    required this.label,
    required this.sub,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String sub;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 6,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (selected) ...[
                const Icon(
                  Icons.check_circle_rounded,
                  size: 14,
                  color: AppColors.onPrimary,
                ),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: selected
                            ? AppColors.onPrimary
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      sub,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: selected
                            ? AppColors.onPrimary.withValues(alpha: 0.75)
                            : AppColors.textTertiary,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Save bar
// ─────────────────────────────────────────────────────────────
