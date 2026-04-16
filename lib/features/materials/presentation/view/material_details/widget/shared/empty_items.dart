import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sams_app/core/utils/assets/app_lottie.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class EmptyItems extends StatelessWidget {
  const EmptyItems({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = SizeConfig.isMobile(context);
    return Column(
      children: [
        Lottie.asset(
          AppLottie.empty,
          width: isMobile ? 180 : 220,
          height: isMobile ? 180 : 220,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 16),
        Text(
          'No files attached to this material.',
          style: (isMobile)
              ? AppStyles.mobileBodySmallRg
              : AppStyles.web15Regular,
        ),
      ],
    );
  }
}
