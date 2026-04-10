import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/quiz_mode.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/shared/empty_state_widget.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/shared/mode_configuration_header.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/shared/question_card.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/manage_quiz_cubit/manage_quiz_cubit.dart';

class ManageQuestionsMobileLayout extends StatelessWidget {
  const ManageQuestionsMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageQuizCubit, ManageQuizState>(
      builder: (context, state) {
        // ─── Loading State ───
        if (state is ManageQuizLoading) {
          return const Scaffold(
            body: Center(child: AppAnimatedLoadingIndicator()),
          );
        }

        // ─── Loaded State ───
        if (state is ManageQuizLoaded) {
          return _ManageQuestionsBody(state: state);
        }

        // ─── Action Loading (overlay handled by parent) ───
        if (state is ManageQuizActionLoading) {
          return const Scaffold(
            body: Center(child: AppAnimatedLoadingIndicator()),
          );
        }

        // ─── Fallback ───
        return const Scaffold(
          body: Center(child: AppAnimatedLoadingIndicator()),
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Main Body — extracted for clarity
// ──────────────────────────────────────────────────────────────────────────────

class _ManageQuestionsBody extends StatelessWidget {
  final ManageQuizLoaded state;

  const _ManageQuestionsBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ManageQuizCubit>();

    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: state.isReadOnly
          ? null
          : _buildBottomBar(context, cubit),
      floatingActionButton: state.canAddNew && state.questions.isNotEmpty
          ? _buildFab(context, cubit)
          : null,
      body: Column(
        children: [
          // ─── Header ───
          ModeConfigurationHeader(
            mode: state.mode,
            questionCount: state.questions.length,
          ),

          // ─── Question List ───
          Expanded(
            child: state.isEmpty
                ? EmptyStateWidget(
                    onAddFirst: state.canAddNew
                        ? () => _showAddQuestionSheet(context, cubit)
                        : null,
                  )
                : _buildQuestionsList(cubit),
          ),
        ],
      ),
    );
  }

  // ──────────── Question List ────────────

  Widget _buildQuestionsList(ManageQuizCubit cubit) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      itemCount: state.questions.length,
      itemBuilder: (context, index) {
        final question = state.questions[index];
        return QuestionCard(
          key: ValueKey(question.localId),
          question: question,
          mode: state.mode,
          index: index,
          onToggleExpand: cubit.toggleQuestionExpanded,
          onRemove: state.mode == QuizMode.edit && !question.isNew
              ? (localId) => _confirmDelete(context, cubit, localId)
              : cubit.removeQuestion,
          onUpdateField: (localId, {text, timeLimit, points}) =>
              cubit.updateQuestionField(
                localId,
                text: text,
                timeLimit: timeLimit,
                points: points,
              ),
          onChangeType: cubit.changeQuestionType,
          onAddOption: cubit.addOption,
          onRemoveOption: cubit.removeOption,
          onUpdateOptionText: cubit.updateOptionText,
          onToggleCorrectOption: cubit.toggleCorrectOption,
        );
      },
    );
  }

  // ──────────── Bottom Bar (Save Button) ────────────

  Widget _buildBottomBar(BuildContext context, ManageQuizCubit cubit) {
    final label = state.mode == QuizMode.draft
        ? 'Save Questions'
        : 'Save Changes';

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
      child: GestureDetector(
        onTap: state.questions.isEmpty ? null : cubit.submitQuestions,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: state.questions.isEmpty
                ? null
                : const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
            color: state.questions.isEmpty ? AppColors.whiteHover : null,
            borderRadius: BorderRadius.circular(16),
            boxShadow: state.questions.isNotEmpty
                ? [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(60),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppStyles.mobileBodySmallMd.copyWith(
              color: state.questions.isEmpty
                  ? AppColors.whiteDarkActive
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ──────────── FAB (Add Question) ────────────

  Widget _buildFab(BuildContext context, ManageQuizCubit cubit) {
    return FloatingActionButton(
      onPressed: () => _showAddQuestionSheet(context, cubit),
      backgroundColor: AppColors.primary,
      elevation: 4,
      child: const Icon(Icons.add_rounded, color: Colors.white),
    );
  }

  // ──────────── Add Question Bottom Sheet ────────────

  void _showAddQuestionSheet(BuildContext context, ManageQuizCubit cubit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.whiteActive,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Add Question',
              style: AppStyles.mobileTitleSmallSb.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Choose a question type to add.',
              style: AppStyles.mobileBodySmallRg.copyWith(
                color: AppColors.whiteDarkActive,
              ),
            ),
            const SizedBox(height: 20),
            _buildSheetOption(
              context: context,
              icon: Icons.edit_note_rounded,
              label: 'Written',
              subtitle: 'Free-form text answer',
              onTap: () {
                Navigator.pop(context);
                cubit.addQuestion(ApiValues.written);
              },
            ),
            const SizedBox(height: 12),
            _buildSheetOption(
              context: context,
              icon: Icons.checklist_rounded,
              label: 'Multiple Choice',
              subtitle: 'Select one correct option',
              onTap: () {
                Navigator.pop(context);
                cubit.addQuestion(ApiValues.mcq);
              },
            ),
            const SizedBox(height: 12),
            _buildSheetOption(
              context: context,
              icon: Icons.toggle_on_outlined,
              label: 'True / False',
              subtitle: 'Binary true or false answer',
              onTap: () {
                Navigator.pop(context);
                cubit.addQuestion(ApiValues.trueFalse);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSheetOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.whiteHover, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppStyles.mobileBodySmallMd.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppStyles.mobileBodyXsmallRg.copyWith(
                      color: AppColors.whiteDarkActive,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.whiteDarkHover,
            ),
          ],
        ),
      ),
    );
  }

  // ──────────── Confirm Delete Dialog (Edit Mode) ────────────

  void _confirmDelete(
    BuildContext context,
    ManageQuizCubit cubit,
    String localId,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Question?',
          style: AppStyles.mobileTitleXsmallMd.copyWith(
            color: AppColors.redDark,
          ),
        ),
        content: Text(
          'This will permanently remove the question from the quiz. This action cannot be undone.',
          style: AppStyles.mobileBodySmallRg.copyWith(
            color: AppColors.whiteDarker,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppStyles.mobileBodySmallMd.copyWith(
                color: AppColors.whiteDarkActive,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              cubit.deleteQuestionFromServer(localId);
            },
            child: Text(
              'Delete',
              style: AppStyles.mobileBodySmallMd.copyWith(
                color: AppColors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
