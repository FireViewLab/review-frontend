import 'package:flutter/material.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_user.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_labels.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

enum _ExpiryOption { unlimited, thirtyDays, custom }

class AdminUserPlanDialog extends StatefulWidget {
  const AdminUserPlanDialog({
    super.key,
    required this.user,
    required this.onSave,
  });

  final AdminUser user;
  final Future<Result<AdminUser>?> Function(
    AdminPlanTier planTier,
    DateTime? expiresAt,
  )
  onSave;

  @override
  State<AdminUserPlanDialog> createState() => _AdminUserPlanDialogState();
}

class _AdminUserPlanDialogState extends State<AdminUserPlanDialog> {
  AdminPlanTier? _plan;
  late _ExpiryOption _expiry;
  DateTime? _date;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    for (final plan in AdminPlanTier.values) {
      if (plan.name.toUpperCase() == widget.user.planTier) _plan = plan;
    }
    _date = widget.user.planExpiresAt;
    _expiry = _date == null ? _ExpiryOption.unlimited : _ExpiryOption.custom;
  }

  Future<void> _pickDate() async {
    final now = DateUtils.dateOnly(DateTime.now());
    final last = DateTime(2100, 12, 31);
    final initial = _date == null || _date!.isBefore(now)
        ? now
        : _date!.isAfter(last)
        ? last
        : _date!;
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now,
      lastDate: last,
    );
    if (!mounted || date == null) return;
    setState(() {
      // 선택한 날짜의 끝까지 이용할 수 있도록 한다.
      _date = DateTime(date.year, date.month, date.day, 23, 59, 59);
      _error = null;
    });
  }

  Future<void> _save() async {
    final plan = _plan;
    if (_saving || plan == null) return;
    final l10n = AppLocalizations.of(context);
    final expiresAt = plan == AdminPlanTier.free
        ? null
        : switch (_expiry) {
            _ExpiryOption.unlimited => null,
            _ExpiryOption.thirtyDays => DateTime.now().add(
              const Duration(days: 30),
            ),
            _ExpiryOption.custom => _date,
          };
    if (plan != AdminPlanTier.free &&
        _expiry == _ExpiryOption.custom &&
        (expiresAt == null || !expiresAt.isAfter(DateTime.now()))) {
      setState(() => _error = l10n.adminUserPlanDateRequired);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final result = await widget.onSave(plan, expiresAt);
    if (!mounted) return;
    setState(() => _saving = false);
    if (result == null) return;
    result.when(
      success: (_) => Navigator.of(context).pop(),
      failure: (failure) => setState(() => _error = failure.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PopScope(
      canPop: !_saving,
      child: AlertDialog(
        insetPadding: const EdgeInsets.all(16),
        title: Text(l10n.adminUserPlanTitle),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(widget.user.email),
                const SizedBox(height: 16),
                DropdownButtonFormField<AdminPlanTier>(
                  key: const ValueKey('admin-plan-tier'),
                  initialValue: _plan,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: l10n.adminUserPlanColumn,
                  ),
                  items: [
                    for (final plan in AdminPlanTier.values)
                      DropdownMenuItem(
                        value: plan,
                        child: Text(plan.localizedLabel(l10n)),
                      ),
                  ],
                  onChanged: _saving
                      ? null
                      : (plan) => setState(() {
                          _plan = plan;
                          _error = null;
                        }),
                ),
                if (_plan != AdminPlanTier.free) ...[
                  const SizedBox(height: 16),
                  DropdownButtonFormField<_ExpiryOption>(
                    initialValue: _expiry,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: l10n.adminUserPlanExpiry,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: _ExpiryOption.unlimited,
                        child: Text(l10n.adminUserPlanUnlimited),
                      ),
                      DropdownMenuItem(
                        value: _ExpiryOption.thirtyDays,
                        child: Text(l10n.adminUserPlanThirtyDays),
                      ),
                      DropdownMenuItem(
                        value: _ExpiryOption.custom,
                        child: Text(l10n.adminUserPlanCustomDate),
                      ),
                    ],
                    onChanged: _saving
                        ? null
                        : (expiry) => setState(() {
                            if (expiry != null) _expiry = expiry;
                            _error = null;
                          }),
                  ),
                  if (_expiry == _ExpiryOption.custom) ...[
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: _saving ? null : _pickDate,
                      child: Text(
                        _date == null
                            ? l10n.adminUserPlanSelectDate
                            : MaterialLocalizations.of(
                                context,
                              ).formatMediumDate(_date!),
                      ),
                    ),
                  ],
                ],
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saving ? null : () => Navigator.of(context).pop(),
            child: Text(l10n.adminUserPlanCancel),
          ),
          FilledButton(
            onPressed: _saving || _plan == null ? null : _save,
            child: Text(
              _saving ? l10n.adminUserPlanSaving : l10n.adminUserPlanSave,
            ),
          ),
        ],
      ),
    );
  }
}
