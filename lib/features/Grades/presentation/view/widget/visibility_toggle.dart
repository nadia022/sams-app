import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

/// Reusable visibility toggle widget with Eye icon and Switch.
/// Used by instructors to show/hide grade columns from students.
class VisibilityToggle extends StatelessWidget {
  const VisibilityToggle({
    super.key,
    required this.isVisible,
    required this.onToggle,
    this.label,
    this.compact = false,
  });

  /// Current visibility state.
  final bool isVisible;

  /// Callback when toggled.
  final ValueChanged<bool> onToggle;

  /// Optional label to show next to the toggle.
  final String? label;

  /// If true, shows only the icon button (no switch).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompactToggle();
    }
    return _buildFullToggle();
  }

  Widget _buildCompactToggle() {
    return InkWell(
      onTap: () => onToggle(!isVisible),
      borderRadius: BorderRadius.circular(6.r),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Icon(
          isVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
          size: 18.sp.clamp(16, 20),
          color: isVisible ? AppColors.primaryHover : AppColors.whiteDarkHover,
        ),
      ),
    );
  }

  Widget _buildFullToggle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppStyles.mobileBodyXsmallRg.copyWith(
              color: AppColors.primaryDark,
            ),
          ),
          SizedBox(width: 6.w),
        ],
        Icon(
          isVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
          size: 16.sp.clamp(14, 18),
          color: isVisible ? AppColors.primaryHover : AppColors.whiteDarkHover,
        ),
        SizedBox(width: 4.w),
        Transform.scale(
          scale: 0.7,
          child: Switch(
            value: isVisible,
            activeThumbColor: AppColors.secondary,
            inactiveThumbColor: AppColors.whiteDark,
            onChanged: onToggle,
          ),
        ),
      ],
    );
  }
}
