import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/features/auth/presentation/view_models/password_reset_state.dart';

class PasswordResetStepIndicator extends StatelessWidget {
  const PasswordResetStepIndicator({super.key, required this.currentStep});

  final PasswordResetStep currentStep;

  @override
  Widget build(BuildContext context) {
    final steps = [
      (PasswordResetStep.email, '이메일 확인'),
      (PasswordResetStep.emailSent, '인증 코드'),
      (PasswordResetStep.newPassword, '새 비밀번호'),
    ];
    final currentIndex = PasswordResetStep.values.indexOf(currentStep);

    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          return Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.only(bottom: 20),
              color: currentIndex > i ~/ 2
                  ? AppColors.primary
                  : AppColors.border,
            ),
          );
        }
        final idx = i ~/ 2;
        final isActive = currentIndex == idx;
        final isDone = currentIndex > idx;
        final bgColor = (isActive || isDone)
            ? AppColors.primary
            : AppColors.border;
        final fgColor = (isActive || isDone)
            ? Colors.white
            : AppColors.textSecondary;
        final labelColor = (isActive || isDone)
            ? AppColors.primary
            : AppColors.textSecondary;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: isDone
                  ? Icon(Icons.check, size: 16, color: fgColor)
                  : Text(
                      '${idx + 1}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: fgColor,
                      ),
                    ),
            ),
            const SizedBox(height: 6),
            Text(
              steps[idx].$2,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: labelColor,
              ),
            ),
          ],
        );
      }),
    );
  }
}
