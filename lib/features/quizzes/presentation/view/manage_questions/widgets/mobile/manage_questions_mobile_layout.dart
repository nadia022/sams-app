import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/editable_question_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/quiz_mode.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/shared/empty_state_widget.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/shared/mode_configuration_header.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/shared/question_card.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/manage_quiz_cubit/manage_quiz_cubit.dart';
import 'package:sams_app/core/utils/router/router_payload_cache.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/manage_questions_args.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'package:go_router/go_router.dart';

class ManageQuestionsMobileLayout extends StatelessWidget {
  const ManageQuestionsMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Only rebuild the main scaffold if it's the initial loading states
    // so we don't destroy local UI state during an ActionLoading event.
    return BlocBuilder<ManageQuizCubit, ManageQuizState>(
      buildWhen: (prev, curr) {
        return curr is ManageQuizInitial ||
               curr is ManageQuizLoading ||
               curr is ManageQuizQuestionsLoaded;
      },
      builder: (context, state) {
        if (state is ManageQuizLoading) {
          return const Scaffold(
            body: Center(child: AppAnimatedLoadingIndicator()),
          );
        }

        if (state is ManageQuizQuestionsLoaded) {
          // Retrieve args since Cubit no longer holds them for UI purposes
          final args = RouterPayloadCache.get<ManageQuestionsArgs>(
            RoutesName.manageQuestions,
            GoRouterState.of(context).extra,
          );

          if (args == null) {
            return const Scaffold(
              body: Center(child: Text('Error loading quiz args')),
            );
          }

          return _ManageQuestionsBody(
            initialQuestions: state.questions,
            args: args,
          );
        }

        return const Scaffold(
          body: Center(child: AppAnimatedLoadingIndicator()),
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Main Body — StatefulWidget holding ALL data interaction limits
// ──────────────────────────────────────────────────────────────────────────────

class _ManageQuestionsBody extends StatefulWidget {
  final List<EditableQuestionModel> initialQuestions;
  final ManageQuestionsArgs args;

  const _ManageQuestionsBody({
    required this.initialQuestions,
    required this.args,
  });

  @override
  State<_ManageQuestionsBody> createState() => _ManageQuestionsBodyState();
}

class _ManageQuestionsBodyState extends State<_ManageQuestionsBody> {
  late List<EditableQuestionModel> _questions;

  @override
  void initState() {
    super.initState();
    _questions = List.from(widget.initialQuestions);
  }

  // ──────────── View-Managed List Logic ────────────

  void _addQuestion(String questionType) {
    setState(() {
      final EditableQuestionModel newQuestion;
      switch (questionType) {
        case ApiValues.written:
          newQuestion = EditableQuestionModel.written();
          break;
        case ApiValues.mcq:
          newQuestion = EditableQuestionModel.mcq();
          break;
        case ApiValues.trueFalse:
          newQuestion = EditableQuestionModel.trueFalse();
          break;
        default:
          return;
      }
      _questions = [..._questions, newQuestion];
    });
  }

  void _removeQuestion(String localId) {
    setState(() {
      _questions = _questions.where((q) => q.localId != localId).toList();
    });
  }

  void _updateQuestionField(
      String localId, {
      String? text,
      int? timeLimit,
      int? points,
      }) {
    setState(() {
      _questions = _questions.map((q) {
        if (q.localId != localId) return q;
        return q.copyWith(
          text: text,
          timeLimit: timeLimit,
          points: points,
        );
      }).toList();
    });
  }

  void _changeQuestionType(String localId, String newType) {
    setState(() {
      _questions = _questions.map((q) {
        if (q.localId != localId) return q;
        if (q.questionType == newType) return q;

        List<EditableOptionModel> newOptions;
        switch (newType) {
          case ApiValues.written:
            newOptions = [];
            break;
          case ApiValues.mcq:
            newOptions = [
              EditableOptionModel.empty(),
              EditableOptionModel.empty(),
            ];
            break;
          case ApiValues.trueFalse:
            newOptions = [
              EditableOptionModel.trueFalse(label: 'True', isCorrect: true),
              EditableOptionModel.trueFalse(label: 'False', isCorrect: false),
            ];
            break;
          default:
            newOptions = [];
        }

        return q.copyWith(questionType: newType, options: newOptions);
      }).toList();
    });
  }

  void _addOption(String questionLocalId) {
    setState(() {
      _questions = _questions.map((q) {
        if (q.localId != questionLocalId || !q.isMcq) return q;
        return q.copyWith(
          options: [...q.options, EditableOptionModel.empty()],
        );
      }).toList();
    });
  }

  void _removeOption(String questionLocalId, String optionLocalId) {
    setState(() {
      _questions = _questions.map((q) {
        if (q.localId != questionLocalId) return q;
        if (q.options.length <= 2) return q;
        return q.copyWith(
          options: q.options.where((o) => o.localId != optionLocalId).toList(),
        );
      }).toList();
    });
  }

  void _updateOptionText(
      String questionLocalId, String optionLocalId, String text) {
    setState(() {
      _questions = _questions.map((q) {
        if (q.localId != questionLocalId) return q;
        return q.copyWith(
          options: q.options.map((o) {
            if (o.localId != optionLocalId) return o;
            return o.copyWith(text: text);
          }).toList(),
        );
      }).toList();
    });
  }

  void _toggleCorrectOption(String questionLocalId, String optionLocalId) {
    setState(() {
      _questions = _questions.map((q) {
        if (q.localId != questionLocalId) return q;
        return q.copyWith(
          options: q.options.map((o) {
            if (o.localId == optionLocalId) return o.copyWith(isCorrect: true);
            return o.copyWith(isCorrect: false);
          }).toList(),
        );
      }).toList();
    });
  }

  // ──────────── Build Methods ────────────

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ManageQuizCubit>();
    final isReadOnly = widget.args.mode == QuizMode.view;
    final canAddNew =
        widget.args.mode == QuizMode.draft || widget.args.mode == QuizMode.edit;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.white,
          bottomNavigationBar:
              isReadOnly ? null : _buildBottomBar(context, cubit),
          floatingActionButton:
              canAddNew && _questions.isNotEmpty ? _buildFab(context) : null,
          body: Column(
            children: [
              ModeConfigurationHeader(
                mode: widget.args.mode,
                questionCount: _questions.length,
              ),
              Expanded(
                child: _questions.isEmpty
                    ? EmptyStateWidget(
                        onAddFirst: canAddNew
                            ? () => _showAddQuestionSheet(context)
                            : null,
                      )
                    : _buildQuestionsList(),
              ),
            ],
          ),
        ),

        // Handle Action Loading Overlay locally so we don't lose widget state
        BlocBuilder<ManageQuizCubit, ManageQuizState>(
          builder: (context, state) {
            if (state is ManageQuizActionLoading) {
              return Container(
                color: Colors.white.withAlpha(120),
                child: const Center(
                  child: AppAnimatedLoadingIndicator(),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildQuestionsList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      itemCount: _questions.length,
      itemBuilder: (context, index) {
        final question = _questions[index];
        return QuestionCard(
          key: ValueKey(question.localId),
          question: question,
          mode: widget.args.mode,
          index: index,
          onRemove: widget.args.mode == QuizMode.edit && !question.isNew
              ? (localId) => _confirmDeleteServer(context, localId)
              : _removeQuestion,
          onUpdateField: _updateQuestionField,
          onChangeType: _changeQuestionType,
          onAddOption: _addOption,
          onRemoveOption: _removeOption,
          onUpdateOptionText: _updateOptionText,
          onToggleCorrectOption: _toggleCorrectOption,
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context, ManageQuizCubit cubit) {
    final label = widget.args.mode == QuizMode.draft
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
        onTap: _questions.isEmpty
            ? null
            : () => cubit.submitQuestions(_questions),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: _questions.isEmpty
                ? null
                : const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
            color: _questions.isEmpty ? AppColors.whiteHover : null,
            borderRadius: BorderRadius.circular(16),
            boxShadow: _questions.isNotEmpty
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
              color: _questions.isEmpty
                  ? AppColors.whiteDarkActive
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showAddQuestionSheet(context),
      backgroundColor: AppColors.primary,
      elevation: 4,
      child: const Icon(Icons.add_rounded, color: Colors.white),
    );
  }

  void _showAddQuestionSheet(BuildContext context) {
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
                _addQuestion(ApiValues.written);
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
                _addQuestion(ApiValues.mcq);
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
                _addQuestion(ApiValues.trueFalse);
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

  void _confirmDeleteServer(BuildContext context, String localId) {
    final cubit = context.read<ManageQuizCubit>();
    final serverId = _questions.firstWhere((q) => q.localId == localId).serverId;

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
              if (serverId != null) {
                // Optimistic local delete before telling server
                _removeQuestion(localId);
                cubit.deleteQuestionFromServer(serverId, _questions);
              }
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
