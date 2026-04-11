import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/enums/text_field_type.dart';
import 'package:sams_app/core/functions/hide_keyboard.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_text_field.dart';
import 'package:sams_app/core/widgets/base/custom_app_button.dart';
import 'package:sams_app/features/profile/presentation/view_model/cubit/profile_cubit.dart';
import 'package:sams_app/features/profile/presentation/view_model/cubit/profile_state.dart';

//* A dialog for updating a user's name on a web device.
class EditNameDialog extends StatefulWidget {
  final String currentName;
  const EditNameDialog({super.key, required this.currentName});

  @override
  State<EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  late TextEditingController _nameController;
  final GlobalKey<FormState> _updateFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive width handling: fixes visibility issues on Web/Desktop
    double dialogWidth = SizeConfig.isMobile(context)
        ? MediaQuery.of(context).size.width
        : 450;

    return AlertDialog(
      backgroundColor: AppColors.whiteLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Center(child: Text('Edit Your Name')),
      titleTextStyle: AppStyles.mobileTitleMediumSb.copyWith(
        color: AppColors.primaryDarkHover,
      ),
      content: Container(
        width: dialogWidth,
        constraints: const BoxConstraints(maxWidth: 450),
        child: Form(
          key: _updateFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                prefixIcon: const Icon(Icons.person_outline),
                hintText: 'Full Name',
                textFieldType: TextFieldType.normal,
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              Text(
                '• Please enter your full name as it should appear on official academic records and communications.',
                style: AppStyles.mobileBodyMediumRg.copyWith(
                  color: AppColors.primaryDark.withAlpha(220),
                ),
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      actions: [
        BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is UpdateNameSuccess) {
              Navigator.pop(context);
              hideKeyboard(context);
            }
          },
          builder: (context, state) {
            if (state is UpdateNameLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.secondary),
              );
            }
            return Row(
              children: [
                Expanded(
                  child: CustomAppButton(
                    label: 'Cancel',
                    height: 40,
                    textColor: AppColors.primaryDark,
                    backgroundColor: AppColors.secondaryLight,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomAppButton(
                    textColor: AppColors.whiteLight,
                    height: 40,
                    label: 'save',
                    onPressed: () => _handleUpdate(context),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _handleUpdate(BuildContext context) {
    final name = _nameController.text.trim();
    if (name.isNotEmpty && name != widget.currentName) {
      context.read<ProfileCubit>().updateName(name);
    } else {
      Navigator.pop(context);
    }
  }
}
