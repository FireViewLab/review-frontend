import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

class HomeLogo extends StatelessWidget {
  const HomeLogo({this.onTap, super.key});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final logo = ClipRect(
      child: SizedBox(
        width: 116,
        height: 36,
        child: Center(
          child: Transform.scale(
            scale: 2,
            child: Image.asset(
              'assets/images/home/brand/review_web_header_logo.webp',
              height: 32,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );

    if (onTap == null) {
      return logo;
    }

    return InkWell(
      borderRadius: AppRadius.small,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: logo,
      ),
    );
  }
}
