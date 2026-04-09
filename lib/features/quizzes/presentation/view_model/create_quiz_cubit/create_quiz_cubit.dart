import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sams_app/features/quizzes/data/repos/quiz_repository.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sams_app/features/quizzes/data/mock_data.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/classwork_item_model.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';
import 'package:sams_app/features/quizzes/data/model/request_bodies_models/create_quiz_request_body.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/model/create_quiz_form_args.dart';

part 'create_quiz_state.dart';

class CreateQuizCubit extends Cubit<CreateQuizState> {
  final QuizRepository _repository;

  // ──────────────────── Form Key ────────────────────
  final formKey = GlobalKey<FormState>();

  // ──────────────────── Controllers ────────────────────
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController durationController;
  late final TextEditingController startTimeDisplayController;

  // ──────────────────── State Variables ────────────────────
  ClassworItemkModel? selectedClasswork;
  DateTime? selectedStartTime;
  bool isEditMode = false;
  QuizModel? initialData;
  late String courseId;

  CreateQuizCubit(this._repository) : super(CreateQuizInitial()) {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    durationController = TextEditingController();
    startTimeDisplayController = TextEditingController();
  }

  /// Initialises controllers from args
  void init(CreateQuizFormArgs args) {
    isEditMode = args.isEditMode;
    initialData = args.initialData;
    courseId = args.courseId;

    if (initialData != null) {
      titleController.text = initialData!.title;
      descriptionController.text = initialData!.description ?? '';
      durationController.text = initialData!.totalTime.toString();
      
      selectedStartTime = initialData!.startTime;
      startTimeDisplayController.text = _formatDateTime(initialData!.startTime);

      selectedClasswork = mockClassworkItems.cast<ClassworItemkModel?>().firstWhere(
        (c) => c != null,
        orElse: () => null,
      );
    }
    
    emit(CreateQuizUIUpdated(DateTime.now()));
  }

  String _formatDateTime(DateTime dt) =>
      DateFormat('MMM dd, yyyy - hh:mm a').format(dt);

  void onClassworkSelected(ClassworItemkModel item) {
    selectedClasswork = item;
    emit(CreateQuizUIUpdated(DateTime.now()));
  }

  void onDateTimePicked(DateTime dt) {
    selectedStartTime = dt;
    startTimeDisplayController.text = _formatDateTime(dt);
    emit(CreateQuizUIUpdated(DateTime.now()));
  }

  void onSubmit() {
    if (!formKey.currentState!.validate()) return;

    final body = CreateQuizRequestBody(
      classworkId: selectedClasswork?.id,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      startTime: selectedStartTime,
      duration: int.tryParse(durationController.text.trim()),
    );

    emit(CreateQuizLoading());

    // Fake API logic for now
    if (isEditMode) {
      debugPrint('[EDIT] PATCH update-quiz → ${body.toJson()}');
      emit(const CreateQuizSuccess('Quiz updated successfully'));
    } else {
      debugPrint('[CREATE] POST create-quiz → ${body.toJson()}');
      emit(const CreateQuizSuccess('Quiz created successfully'));
    }
  }

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    durationController.dispose();
    startTimeDisplayController.dispose();
    return super.close();
  }
}
