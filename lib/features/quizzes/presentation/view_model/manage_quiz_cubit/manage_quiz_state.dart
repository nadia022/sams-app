part of 'manage_quiz_cubit.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Manage Quiz State — Sealed hierarchy
// ──────────────────────────────────────────────────────────────────────────────

sealed class ManageQuizState {
  const ManageQuizState();
}

/// Initial state — before [ManageQuizCubit.init] is called.
final class ManageQuizInitial extends ManageQuizState {}

/// Questions are being fetched from the API (edit / view mode).
final class ManageQuizLoading extends ManageQuizState {}

/// The primary "working" state — the loaded list + mode.
///
/// This is emitted after:
/// - Draft init (empty list)
/// - Successful API fetch (edit/view)
/// - Any local list mutation (add/remove/update question/option)
final class ManageQuizLoaded extends ManageQuizState {
  final QuizMode mode;
  final List<EditableQuestionModel> questions;
  final String quizId;
  final String? quizTitle;
  final bool isDirty;

  const ManageQuizLoaded({
    required this.mode,
    required this.questions,
    required this.quizId,
    this.quizTitle,
    this.isDirty = false,
  });

  // ──────────── Convenience Getters ────────────

  bool get isReadOnly => mode == QuizMode.view;
  bool get canAddNew => mode == QuizMode.draft || mode == QuizMode.edit;
  bool get isEmpty => questions.isEmpty;

  // ──────────── CopyWith ────────────

  ManageQuizLoaded copyWith({
    List<EditableQuestionModel>? questions,
    bool? isDirty,
  }) {
    return ManageQuizLoaded(
      mode: mode,
      questions: questions ?? this.questions,
      quizId: quizId,
      quizTitle: quizTitle,
      isDirty: isDirty ?? this.isDirty,
    );
  }
}

/// An API action (add/update/delete) is in progress.
final class ManageQuizActionLoading extends ManageQuizState {}

/// An API action succeeded — transient state consumed by BlocListener.
final class ManageQuizSuccess extends ManageQuizState {
  final String message;
  const ManageQuizSuccess(this.message);
}

/// An error occurred.
final class ManageQuizFailure extends ManageQuizState {
  final String message;
  const ManageQuizFailure(this.message);
}
