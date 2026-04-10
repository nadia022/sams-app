import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

/// An empty state widget shown in Draft mode when no questions exist yet.
class EmptyStateWidget extends StatelessWidget {
  final VoidCallback? onAddFirst;

  const EmptyStateWidget({super.key, this.onAddFirst});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ─── Icon ───
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.quiz_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),

            // ─── Title ───
            Text(
              'No Questions Yet',
              style: AppStyles.mobileTitleSmallSb.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 8),

            // ─── Subtitle ───
            Text(
              'Start building your quiz by tapping the\nbutton below to add your first question.',
              textAlign: TextAlign.center,
              style: AppStyles.mobileBodySmallRg.copyWith(
                color: AppColors.whiteDarkActive,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // ─── CTA Button ───
            if (onAddFirst != null)
              GestureDetector(
                onTap: onAddFirst,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(80),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Add First Question',
                        style: AppStyles.mobileBodySmallMd.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
