import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

class AppLoadingView extends StatelessWidget {
  const AppLoadingView({
    this.message,
    this.indicatorSize = 32,
    this.centered = true,
    super.key,
  });

  final String? message;
  final double indicatorSize;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: indicatorSize,
          child: TickerMode(
            enabled: !MediaQuery.disableAnimationsOf(context),
            child: const CircularProgressIndicator(strokeWidth: 3),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(message!, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ],
    );

    if (!centered) {
      return content;
    }

    return Center(child: content);
  }
}
