import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

/// Reusable empty state widget for grades views.
/// Shows a centered icon, title, and optional subtitle.
class GradesEmptyState extends StatelessWidget {
  const GradesEmptyState({
    super.key,
    this.icon = Icons.school_outlined,
    this.title = 'No grades found',
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 48.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 80.w,
              height: 80.w,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40.sp.clamp(36, 48),
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 20.h),

            // Title
            Text(
              title,
              style: AppStyles.mobileBodyLargeMd.copyWith(
                color: AppColors.primaryDark,
              ),
              textAlign: TextAlign.center,
            ),

            // Subtitle
            if (subtitle != null) ...[
              SizedBox(height: 8.h),
              Text(
                subtitle!,
                style: AppStyles.mobileBodySmallRg.copyWith(
                  color: AppColors.whiteDarkHover,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
