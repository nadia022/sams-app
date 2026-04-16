
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sams_app/core/utils/assets/app_icons.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/materials/presentation/logic/material_navigation_handler.dart';

class AddMaterialItemsFloatingBuutton extends StatelessWidget {
  const AddMaterialItemsFloatingBuutton({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.primary,
      onPressed: () => MaterialsNavigationHandler.showAddMaterialItemsDialog(
        context,
        courseId: courseId,
      ),
      child: SvgPicture.asset(
        AppIcons.iconsPlusFloatingButton,
        colorFilter: const ColorFilter.mode(
          AppColors.whiteLight,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
