import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sams_app/core/enums/text_field_type.dart';
import 'package:sams_app/core/models/app_button_style_model.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_button.dart';
import 'package:sams_app/core/widgets/base/app_text_field.dart';
import 'package:sams_app/core/widgets/mobile/mobile_custom_app_bar.dart';
import 'package:sams_app/core/widgets/shared/titled_input_field.dart';
import 'package:sams_app/features/quizzes/data/mock_data.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/classwork_item_model.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';
import 'package:sams_app/features/quizzes/data/model/request_bodies_models/create_quiz_request_body.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/widgets/shared/classwork_selector_field.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/model/create_quiz_form_args.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/create_quiz_cubit/create_quiz_cubit.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/widgets/shared/date_time_picker_field.dart';

/// A unified "Smart Form" screen for both creating and editing a quiz.
///
/// Behaviour is driven entirely by [CreateQuizFormArgs]:
/// - [CreateQuizFormArgs.isEditMode] == false → Create mode (blank form, "Create Quiz" title)
/// - [CreateQuizFormArgs.isEditMode] == true  → Edit mode (pre-filled form, "Edit Quiz" title,
///   classwork field locked)
///
/// Data flow is ready for Cubit integration — see the TODO comments at the
/// submit handler.
class CreateQuizMobileLayout extends StatelessWidget {

  const CreateQuizMobileLayout({super.key});

  // ──────────────────── Date & Time Picker ────────────────────
  Future<void> _pickStartDateTime(BuildContext context) async {
    final cubit = context.read<CreateQuizCubit>();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: cubit.selectedStartTime ?? DateTime.now(),
      firstDate: DateTime.now(), // Prohibits past dates
      lastDate: DateTime(2100),
    );
    if (pickedDate == null || !context.mounted) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: cubit.selectedStartTime != null
          ? TimeOfDay.fromDateTime(cubit.selectedStartTime!)
          : TimeOfDay.now(),
    );
    if (pickedTime == null || !context.mounted) return;

    final combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    cubit.onDateTimePicked(combined);
  }

  // ──────────────────── Build ────────────────────

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateQuizCubit>();

    return BlocBuilder<CreateQuizCubit, CreateQuizState>(
      buildWhen: (previous, current) => current is CreateQuizUIUpdated,
      builder: (context, state) {
        return Scaffold(
          appBar: MobileCustomAppBar(
            title: cubit.isEditMode ? 'Edit Quiz' : 'Create Quiz',
          ),
          bottomNavigationBar: _buildBottomButton(context),
          body: SafeArea(
            child: Form(
              key: cubit.formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  _SectionHeader(isEditMode: cubit.isEditMode),
                  const SizedBox(height: 24),

                  // ─── Assigned Classwork ───
                  TitledInputField(
                    label: 'Assigned Classwork',
                    child: ClassworkSelectorField(
                      selectedClasswork: cubit.selectedClasswork,
                      classworkItems: mockClassworkItems,
                      onSelected: cubit.onClassworkSelected,
                      // Locked in edit mode — cannot re-assign the classwork
                      isReadOnly: cubit.isEditMode,
                    ),
                  ),
                  // Hint shown only in edit mode to explain why the field is locked
                  if (cubit.isEditMode) ...[
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        'The assigned classwork cannot be changed after creation.',
                        style: AppStyles.mobileBodyXsmallRg.copyWith(
                          color: AppColors.whiteDarkHover,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),

                  // ─── Title ───
                  TitledInputField(
                    label: 'Title',
                    child: AppTextField(
                      hintText: 'Enter quiz title',
                      controller: cubit.titleController,
                      textFieldType: TextFieldType.normal,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ─── Description ───
                  TitledInputField(
                    label: 'Description',
                    child: AppTextField(
                      hintText: 'Enter a brief description (optional)',
                      controller: cubit.descriptionController,
                      textFieldType: TextFieldType.normal,
                      minLines: 3,
                      textInputAction: TextInputAction.newline,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ─── Start Time ───
                  TitledInputField(
                    label: 'Start Time',
                    child: DateTimePickerField(
                      controller: cubit.startTimeDisplayController,
                      onTap: () => _pickStartDateTime(context),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ─── Duration ───
                  TitledInputField(
                    label: 'Duration',
                    child: _DurationInputField(controller: cubit.durationController),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ──────────────────── Bottom Button ────────────────────

  Widget _buildBottomButton(BuildContext context) {
    final cubit = context.read<CreateQuizCubit>();
    
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.whiteLight,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: AppButton(
        model: AppButtonStyleModel(
          label: cubit.isEditMode ? 'Save Changes' : 'Continue',
          onPressed: cubit.onSubmit,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  Private sub-widgets (scoped to this file — not reused elsewhere)
// ══════════════════════════════════════════════════════════════

/// Contextual header with title and subtitle that adapts to the form mode.
class _SectionHeader extends StatelessWidget {
  final bool isEditMode;
  const _SectionHeader({required this.isEditMode});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEditMode ? 'Edit Quiz Details' : 'Quiz Details',
          style: AppStyles.mobileTitleSmallSb.copyWith(
            color: AppColors.primaryDarkHover,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isEditMode
              ? 'Update the fields below and save your changes.'
              : 'Fill in the details to create a new quiz for your students.',
          style: AppStyles.mobileBodyXsmallRg.copyWith(
            color: AppColors.whiteDarkActive,
          ),
        ),
      ],
    );
  }
}

/// Digits-only field for quiz duration in minutes.
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

        const SizedBox(height: 6),

        // Helper subtext
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            'The time limit for the student to complete the quiz',
            style: AppStyles.mobileBodyXsmallRg.copyWith(
              color: AppColors.whiteDarkActive,
            ),
          ),
        ),
      ],
    );
  }
}
