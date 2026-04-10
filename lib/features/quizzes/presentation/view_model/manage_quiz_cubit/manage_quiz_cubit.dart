import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/quizzes/data/model/request_bodies_models/add_question/add_questions_request_body.dart';
import 'package:sams_app/features/quizzes/data/repos/quiz_repository.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/editable_question_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/manage_questions_args.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/quiz_mode.dart';

part 'manage_quiz_state.dart';

class ManageQuizCubit extends Cubit<ManageQuizState> {
  final QuizRepository _repository;

  ManageQuizCubit(this._repository) : super(ManageQuizInitial());

  // ──────────── Internal State ────────────
  late String _quizId;
  late QuizMode _mode;
  String? _quizTitle;
  List<EditableQuestionModel> _questions = [];
  bool _isDirty = false;

  /// Snapshot of the last emitted loaded state — used to restore after
  /// transient success/failure states.
  ManageQuizLoaded? _lastLoaded;

  // ──────────────────────────────────────────────────────────────────────────
  // Initialization
  // ──────────────────────────────────────────────────────────────────────────

  /// Entry point called by the router after the Cubit is created.
  ///
  /// - **Draft mode**: starts with an empty list.
  /// - **Edit / View mode**: fetches questions from the API.
  Future<void> init(ManageQuestionsArgs args) async {
    _quizId = args.quizId;
    _mode = args.mode;
    _quizTitle = args.quizTitle;

    if (_mode == QuizMode.draft) {
      _questions = [];
      _emitLoaded();
    } else {
      await _fetchQuestions();
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Question CRUD (local list manipulation)
  // ──────────────────────────────────────────────────────────────────────────

  /// Adds a new question of the given [questionType] to the bottom of the list.
  /// Collapses all other cards so the new one is the only one expanded.
  void addQuestion(String questionType) {
    // Collapse all existing questions
    _questions = _questions
        .map((q) => q.isExpanded ? q.copyWith(isExpanded: false) : q)
        .toList();

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
    _isDirty = true;
    _emitLoaded();
  }

  /// Removes a question by its [localId].
  void removeQuestion(String localId) {
    _questions = _questions.where((q) => q.localId != localId).toList();
    _isDirty = true;
    _emitLoaded();
  }

  /// Updates a single field of a question by [localId].
  ///
  /// Called on focus-loss (not every keystroke) for performance.
  void updateQuestionField(
    String localId, {
    String? text,
    int? timeLimit,
    int? points,
  }) {
    _questions = _questions.map((q) {
      if (q.localId != localId) return q;
      return q.copyWith(
        text: text,
        timeLimit: timeLimit,
        points: points,
      );
    }).toList();
    _isDirty = true;
    _emitLoaded();
  }

  /// Changes the question type for a question. Resets options accordingly.
  void changeQuestionType(String localId, String newType) {
    _questions = _questions.map((q) {
      if (q.localId != localId) return q;
      if (q.questionType == newType) return q;

      // Reset options based on the new type
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
    _isDirty = true;
    _emitLoaded();
  }

  /// Toggles the expand/collapse state of a question card.
  void toggleQuestionExpanded(String localId) {
    _questions = _questions.map((q) {
      if (q.localId != localId) return q;
      return q.copyWith(isExpanded: !q.isExpanded);
    }).toList();
    _emitLoaded();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Option CRUD
  // ──────────────────────────────────────────────────────────────────────────

  /// Adds a new empty option to an MCQ question.
  void addOption(String questionLocalId) {
    _questions = _questions.map((q) {
      if (q.localId != questionLocalId || !q.isMcq) return q;
      return q.copyWith(
        options: [...q.options, EditableOptionModel.empty()],
      );
    }).toList();
    _isDirty = true;
    _emitLoaded();
  }

  /// Removes an option from an MCQ question (minimum 2 options enforced).
  void removeOption(String questionLocalId, String optionLocalId) {
    _questions = _questions.map((q) {
      if (q.localId != questionLocalId) return q;
      if (q.options.length <= 2) return q; // Enforce minimum
      return q.copyWith(
        options: q.options.where((o) => o.localId != optionLocalId).toList(),
      );
    }).toList();
    _isDirty = true;
    _emitLoaded();
  }

  /// Updates the text of a specific option.
  void updateOptionText(
    String questionLocalId,
    String optionLocalId,
    String text,
  ) {
    _questions = _questions.map((q) {
      if (q.localId != questionLocalId) return q;
      return q.copyWith(
        options: q.options.map((o) {
          if (o.localId != optionLocalId) return o;
          return o.copyWith(text: text);
        }).toList(),
      );
    }).toList();
    _isDirty = true;
    _emitLoaded();
  }

  /// Toggles the correct answer for a specific option.
  ///
  /// For MCQ: only one option can be correct — all others are deselected.
  /// For TRUE_FALSE: toggling one auto-toggles the other.
  void toggleCorrectOption(String questionLocalId, String optionLocalId) {
    _questions = _questions.map((q) {
      if (q.localId != questionLocalId) return q;

      return q.copyWith(
        options: q.options.map((o) {
          if (o.localId == optionLocalId) {
            return o.copyWith(isCorrect: true);
          }
          return o.copyWith(isCorrect: false);
        }).toList(),
      );
    }).toList();
    _isDirty = true;
    _emitLoaded();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // API Submission
  // ──────────────────────────────────────────────────────────────────────────

  /// Batch-submits all questions (draft mode) or saves all changes (edit mode).
  Future<void> submitQuestions() async {
    if (_questions.isEmpty) {
      emit(const ManageQuizFailure('Please add at least one question.'));
      _restoreLoaded();
      return;
    }

    // Validate all questions have text
    for (int i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      if (q.text.trim().isEmpty) {
        emit(ManageQuizFailure('Question ${i + 1} is missing its text.'));
        _restoreLoaded();
        return;
      }
      // Validate MCQ options
      if (q.isMcq || q.isTrueFalse) {
        final hasCorrect = q.options.any((o) => o.isCorrect);
        if (!hasCorrect) {
          emit(ManageQuizFailure(
            'Question ${i + 1} needs a correct answer selected.',
          ));
          _restoreLoaded();
          return;
        }
        if (q.isMcq) {
          final emptyOpts = q.options.where((o) => o.text.trim().isEmpty);
          if (emptyOpts.isNotEmpty) {
            emit(ManageQuizFailure(
              'Question ${i + 1} has empty option(s).',
            ));
            _restoreLoaded();
            return;
          }
        }
      }
    }

    emit(ManageQuizActionLoading());

    try {
      if (_mode == QuizMode.draft) {
        // ─── Batch Add (POST) ───
        final body = _toRequestBody();
        final result = await _repository.addQuestion(_quizId, body.toJson());

        result.fold(
          (error) {
            emit(ManageQuizFailure(error));
            _restoreLoaded();
          },
          (successMsg) {
            _isDirty = false;
            emit(const ManageQuizSuccess('Questions added successfully!'));
            _restoreLoaded();
          },
        );
      } else if (_mode == QuizMode.edit) {
        // ─── Sequential Updates (PATCH) for modified existing questions ───
        // ─── Plus batch Add (POST) for newly added questions ───
        final newQuestions = _questions.where((q) => q.isNew).toList();
        final existingQuestions = _questions.where((q) => !q.isNew).toList();

        // Update existing questions one by one
        for (final question in existingQuestions) {
          final dto = question.toDto();
          final result = await _repository.updateQuestion(
            question.serverId!,
            dto.toJson(),
          );
          final failed = result.fold<bool>(
            (error) {
              emit(ManageQuizFailure(error));
              _restoreLoaded();
              return true;
            },
            (_) => false,
          );
          if (failed) return;
        }

        // Batch add new questions if any
        if (newQuestions.isNotEmpty) {
          final body = AddQuestionsRequestBody(
            questions: newQuestions.map((q) => q.toDto()).toList(),
          );
          final result = await _repository.addQuestion(
            _quizId,
            body.toJson(),
          );
          final failed = result.fold<bool>(
            (error) {
              emit(ManageQuizFailure(error));
              _restoreLoaded();
              return true;
            },
            (_) => false,
          );
          if (failed) return;
        }

        _isDirty = false;
        emit(const ManageQuizSuccess('Changes saved successfully!'));
        _restoreLoaded();
      }
    } catch (e) {
      emit(ManageQuizFailure('Something went wrong: ${e.toString()}'));
      _restoreLoaded();
    }
  }

  /// Deletes a question from the server (edit mode only).
  Future<void> deleteQuestionFromServer(String localId) async {
    final question = _questions.firstWhere((q) => q.localId == localId);

    if (question.isNew) {
      // Not on the server yet — just remove locally
      removeQuestion(localId);
      return;
    }

    emit(ManageQuizActionLoading());

    try {
      final result = await _repository.deleteQuestion(question.serverId!);
      result.fold(
        (error) {
          emit(ManageQuizFailure(error));
          _restoreLoaded();
        },
        (_) {
          _questions =
              _questions.where((q) => q.localId != localId).toList();
          emit(const ManageQuizSuccess('Question deleted.'));
          _emitLoaded();
        },
      );
    } catch (e) {
      emit(ManageQuizFailure('Failed to delete: ${e.toString()}'));
      _restoreLoaded();
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Internal Helpers
  // ──────────────────────────────────────────────────────────────────────────

  /// Fetches questions from the API (used in edit/view modes).
  Future<void> _fetchQuestions() async {
    emit(ManageQuizLoading());

    final result = await _repository.getQuizQuestions(_quizId);
    result.fold(
      (error) => emit(ManageQuizFailure(error)),
      (questions) {
        _questions = questions
            .map((q) => EditableQuestionModel.fromServer(q))
            .toList();
        _emitLoaded();
      },
    );
  }

  /// Converts the internal list to an API request body.
  AddQuestionsRequestBody _toRequestBody() {
    return AddQuestionsRequestBody(
      questions: _questions.map((q) => q.toDto()).toList(),
    );
  }

  /// Emits a [ManageQuizLoaded] state and caches it for restoration.
  void _emitLoaded() {
    _lastLoaded = ManageQuizLoaded(
      mode: _mode,
      questions: List.unmodifiable(_questions),
      quizId: _quizId,
      quizTitle: _quizTitle,
      isDirty: _isDirty,
    );
    emit(_lastLoaded!);
  }

  /// Restores the last loaded state (after transient success/failure).
  void _restoreLoaded() {
    if (_lastLoaded != null) {
      // Re-emit with potentially updated isDirty
      _lastLoaded = _lastLoaded!.copyWith(isDirty: _isDirty);
      emit(_lastLoaded!);
    }
  }
}
