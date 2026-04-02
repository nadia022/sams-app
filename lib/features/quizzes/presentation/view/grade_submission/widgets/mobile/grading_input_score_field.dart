import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class GradingScoreField extends StatelessWidget {
  final String questionId;
  final int maxPoints;
  final num earnedPoints;
  final bool isGraded;

  const GradingScoreField({
    super.key,
    required this.questionId,
    required this.maxPoints,
    required this.earnedPoints,
    required this.isGraded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85,
      height: 40,
      decoration: BoxDecoration(
        color: isGraded ? AppColors.primaryLight.withOpacity(0.4) : AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isGraded ? AppColors.primary : StatusColors.orange,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: AppStyles.mobileBodyLargeSb.copyWith(
                color: AppColors.black,
              ),
              controller: TextEditingController(text: isGraded ? '$earnedPoints' : ''),
              onSubmitted: (val) {
                // TODO: Save logic via Cubit
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              '/ $maxPoints',
              style: AppStyles.mobileBodyXsmallMd.copyWith(color: AppColors.whiteDarkActive),
            ),
          ),
        ],
      ),
    );
  }
}