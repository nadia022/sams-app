import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

/// A compact row with Points and Time Limit inputs side by side.
///
/// Both fields accept only numeric input and support read-only mode.
class PointsTimeRow extends StatelessWidget {
  final TextEditingController pointsController;
  final TextEditingController timeLimitController;
  final bool enabled;
  final VoidCallback? onPointsEditingComplete;
  final VoidCallback? onTimeLimitEditingComplete;

  const PointsTimeRow({
    super.key,
    required this.pointsController,
    required this.timeLimitController,
    this.enabled = true,
    this.onPointsEditingComplete,
    this.onTimeLimitEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildField(
            label: 'Points',
            controller: pointsController,
            icon: Icons.star_rounded,
            onEditingComplete: onPointsEditingComplete,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildField(
            label: 'Time (sec)',
            controller: timeLimitController,
            icon: Icons.timer_rounded,
            onEditingComplete: onTimeLimitEditingComplete,
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    VoidCallback? onEditingComplete,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.mobileBodyXsmallMd.copyWith(
            color: AppColors.whiteDarker,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onEditingComplete: onEditingComplete,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: AppStyles.mobileBodySmallMd.copyWith(
            color: AppColors.primaryDark,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18, color: AppColors.primary),
            filled: true,
            fillColor: enabled ? AppColors.whiteLight : AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: AppColors.whiteActive, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: AppColors.whiteActive, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: AppColors.whiteHover, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
