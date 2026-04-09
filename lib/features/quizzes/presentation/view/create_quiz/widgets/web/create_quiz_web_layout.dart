import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/enums/text_field_type.dart';
import 'package:sams_app/core/models/app_button_style_model.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_button.dart';
import 'package:sams_app/core/widgets/base/app_text_field.dart';
import 'package:sams_app/core/widgets/shared/titled_input_field.dart';
import 'package:sams_app/features/quizzes/data/mock_data.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/widgets/shared/classwork_selector_field.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/widgets/shared/date_time_picker_field.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/create_quiz_cubit/create_quiz_cubit.dart';

class CreateQuizWebLayout extends StatelessWidget {
  const CreateQuizWebLayout({super.key});

  Future<void> _pickStartDateTime(BuildContext context) async {
    final cubit = context.read<CreateQuizCubit>();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Prohibits past dates
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.primaryDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null || !context.mounted) return;
    cubit.updateDate(pickedDate);

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.primaryDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null || !context.mounted) return;
    cubit.updateTime(pickedTime);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateQuizCubit>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          cubit.isEditMode ? 'Edit Quiz' : 'Create New Assessment',
          style: AppStyles.mobileTitleMediumSb.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 8.0,
            ),
            child: BlocBuilder<CreateQuizCubit, CreateQuizState>(
              builder: (context, state) {
                final isLoading = state is CreateQuizLoading;
                return SizedBox(
                  width: 150,
                  child: AppButton(
                    model: AppButtonStyleModel(
                      label: cubit.isEditMode ? 'Save Changes' : 'Create Quiz',
                      onPressed: isLoading ? () {} : cubit.onSubmit,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Form(
            key: cubit.formKey,
            child: ListView(
              padding: const EdgeInsets.all(32),
              children: [
                _buildHeader(cubit.isEditMode),
                const SizedBox(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column (Details)
                    Expanded(
                      flex: 3,
                      child: _buildDetailsCard(cubit),
                    ),
                    const SizedBox(width: 32),
                    // Right Column (Settings)
                    Expanded(
                      flex: 2,
                      child: _buildSettingsCard(context, cubit),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isEditMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isEditMode ? 'MODIFICATION MODE' : 'NEW ASSIGNMENT',
            style: AppStyles.mobileBodyXsmallRg.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          isEditMode ? 'Edit Quiz Details' : 'Create New Quiz',
          style: AppStyles.mobileTitleMediumSb.copyWith(
            color: AppColors.primaryDark,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isEditMode
              ? 'Make sure to double-check the timing and classwork before saving.'
              : 'Fill in the details to set up a new assessment for your class.',
          style: AppStyles.mobileBodyMediumRg.copyWith(
            color: AppColors.whiteDarkActive,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsCard(CreateQuizCubit cubit) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.whiteHover, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'General Information',
            style: AppStyles.mobileTitleSmallSb.copyWith(
              color: AppColors.primaryDarkHover,
            ),
          ),
          const SizedBox(height: 24),
          if (!cubit.isEditMode) ...[
            BlocBuilder<CreateQuizCubit, CreateQuizState>(
              buildWhen: (prev, curr) => curr is CreateQuizUIUpdated,
              builder: (context, state) {
                return TitledInputField(
                  label: 'Assigned Classwork',
                  child: ClassworkSelectorField(
                    selectedClasswork: cubit.selectedClasswork,
                    classworkItems: mockClassworkItems,
                    onSelected: cubit.onClassworkSelected,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
          TitledInputField(
            label: 'Quiz Title',
            child: AppTextField(
              hintText: 'Enter quiz title',
              controller: cubit.titleController,
              textFieldType: TextFieldType.normal,
              textInputAction: TextInputAction.next,
            ),
          ),
          const SizedBox(height: 24),
          TitledInputField(
            label: 'Description',
            child: AppTextField(
              hintText: 'Enter a brief description for the students',
              controller: cubit.descriptionController,
              textFieldType: TextFieldType.normal,
              minLines: 4,
              textInputAction: TextInputAction.newline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, CreateQuizCubit cubit) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.whiteHover, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Timing & Access',
            style: AppStyles.mobileTitleSmallSb.copyWith(
              color: AppColors.primaryDarkHover,
            ),
          ),
          const SizedBox(height: 24),
          BlocBuilder<CreateQuizCubit, CreateQuizState>(
            buildWhen: (prev, curr) => curr is CreateQuizUIUpdated,
            builder: (context, state) {
              return TitledInputField(
                label: 'Start Date & Time',
                child: DateTimePickerField(
                  controller: cubit.startTimeDisplayController,
                  onTap: () => _pickStartDateTime(context),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          TitledInputField(
            label: 'Duration',
            child: _DurationInputField(
              controller: cubit.durationController,
            ),
          ),
        ],
      ),
    );
  }
}

class _DurationInputField extends StatelessWidget {
  final TextEditingController controller;
  const _DurationInputField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          controller: controller,
          hintText: 'e.g. 30',
          textFieldType: TextFieldType.numerical,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'mins',
                  style: AppStyles.mobileBodySmallMd.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              size: 16,
              color: AppColors.primaryDark,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Access deadline. Students can start until the last minute and finish their full attempt.',
                style: AppStyles.mobileBodyXsmallRg.copyWith(
                  color: AppColors.whiteDarkActive,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
