// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:sams_app/core/utils/mixins/cubit_message_mixin.dart';
// import 'package:sams_app/core/utils/mixins/safe_emit_mixin.dart';
// import 'package:sams_app/features/assignments/data/repos/assignment_repo.dart';
// import 'package:sams_app/features/assignments/presentation/view_model/cubits/create_assignment/create_assignment_state.dart';

// //* Handles Assignment Creation only.
// class CreateAssignmentCubit extends Cubit<CreateAssignmentState>
//     with CubitMessageMixin, SafeEmitMixin {
//   final AssignmentRepo assignmentRepo;

//   CreateAssignmentCubit(this.assignmentRepo) : super(CreateAssignmentInitial());

//   //* Full Workflow: Request Presigned URLs → S3 Upload → Backend Confirmation
//   Future<void> createAssignment({
//     required String courseId,
//     required String title,
//     required String description,
//     required String dueDate,
//     required List<XFile> selectedFiles,
//   }) async {
//     // 1. Show loading state (with file upload indicator if needed)
//     emit(
//       CreateAssignmentLoading(isUploadingFiles: selectedFiles.isNotEmpty),
//     );

//     // 2. Execute the full creation workflow in the repository
//     final result = await assignmentRepo.uploadAssignmentFullWorkflow(
//       courseId: courseId,
//       title: title,
//       description: description,
//       dueDate: dueDate,
//       selectedFiles: selectedFiles,
//     );

//     result.fold(
//       (failure) {
//         // Show error message via mixin
//         emitMessage(failure);
//         emit(CreateAssignmentFailure(failure));
//       },
//       (newAssignment) {
//         // Success logic: Notify refresh trigger if you use one
//         // AssignmentRefreshTrigger.requestRefresh();

//         emit(
//           CreateAssignmentSuccess(
//             assignment: newAssignment,
//             message: 'Assignment created successfully!',
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sams_app/core/utils/mixins/cubit_message_mixin.dart';
import 'package:sams_app/core/utils/mixins/safe_emit_mixin.dart';
import 'package:sams_app/features/assignments/data/repos/assignment_repo.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/classwork_item_model.dart';
import 'package:sams_app/features/quizzes/data/repos/quiz_repository.dart';
import 'create_assignment_state.dart';

class CreateAssignmentCubit extends Cubit<CreateAssignmentState>
    with CubitMessageMixin, SafeEmitMixin {
  final AssignmentRepo assignmentRepo;
  final QuizRepository quizRepo;

  CreateAssignmentCubit({
    required this.assignmentRepo,
    required this.quizRepo,
  }) : super(CreateAssignmentInitial()) {
    _initControllers();
  }

  // ── Form Elements ─────────────────────────────────────────────────────────
  final formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController dueDateDisplayController;

  // ── Data Variables ────────────────────────────────────────────────────────
  ClassworkItemModel? selectedClasswork;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  late String courseId;
  bool enablePlagiarism = false;
  int plagiarismThreshold = 30;

  void _initControllers() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    dueDateDisplayController = TextEditingController();
  }

  /// Initialises the cubit with the course ID.
  void init(String courseId) {
    this.courseId = courseId;
    emit(CreateAssignmentUIUpdated());
  }

  // ── Classwork Actions (Shared from Quiz Logic) ───────────────────────────

  void onClassworkSelected(ClassworkItemModel item) {
    selectedClasswork = item;
    emit(CreateAssignmentUIUpdated());
  }

  Future<void> getAvailableClassworks() async {
    emit(AvailableClassworksLoading());

    final result = await quizRepo.getAvailableClassworks(courseId);
    result.fold(
      (failureMessage) => emit(AvailableClassworksFailure(failureMessage)),
      (classworks) => emit(AvailableClassworksLoaded(classworks)),
    );
  }

  Future<void> addNewClasswork(String classworkName, num totalPoints) async {
    emit(CreateClassworkLoading());

    final result = await quizRepo.addNewClasswork(
      courseId,
      classworkName,
      totalPoints,
    );
    result.fold(
      (failureMessage) => emit(CreateClassworkFailure(failureMessage)),
      (successMessage) {
        emit(CreateClassworkSuccess(successMessage));
        getAvailableClassworks(); 
      },
    );
  }

  // ── Date/Time Actions ────────────────────────────────────────────────────

  void updateDate(DateTime date) {
    _selectedDate = date;
    _combineAndSyncDateTime();
  }

  void updateTime(TimeOfDay time) {
    _selectedTime = time;
    _combineAndSyncDateTime();
  }

  void _combineAndSyncDateTime() {
    if (_selectedDate != null && _selectedTime != null) {
      final combined = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      dueDateDisplayController.text = _formatDateTime(combined);
      emit(CreateAssignmentUIUpdated());
    }
  }

  String _formatDateTime(DateTime dt) =>
      DateFormat('MMM dd, yyyy - hh:mm a').format(dt);

  // ── Main Submit Action ───────────────────────────────────────────────────

  Future<void> onSubmit({required List<XFile> selectedFiles}) async {
    // 1. Validation
    if (selectedClasswork == null) {
      emitMessage('Please select a classwork first.');
      return;
    }

    if (!formKey.currentState!.validate()) return;

    if (_selectedDate == null || _selectedTime == null) {
      emitMessage('Please select a due date.');
      return;
    }

    // 2. Prepare Data
    final DateTime currentDueDate = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    // 3. Execution
    emit(
      CreateAssignmentLoading(isUploadingFiles: selectedFiles.isNotEmpty),
    );

    final result = await assignmentRepo.uploadAssignmentFullWorkflow(
      courseId: courseId,
      classworkId: selectedClasswork!.id,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      dueDate: currentDueDate.toIso8601String(),
      selectedFiles: selectedFiles,
      enablePlagiarismCheck: enablePlagiarism,
      plagiarismThreshold: plagiarismThreshold,
    );

    result.fold(
      (failure) {
        emitMessage(failure);
        emit(CreateAssignmentFailure(failure));
      },
      (newAssignment) {
        emit(
          CreateAssignmentSuccess(
            assignment: newAssignment,
            message: 'Assignment created successfully!',
          ),
        );
      },
    );
  }

  void togglePlagiarism(bool value) {
    enablePlagiarism = value;
    emit(
      CreateAssignmentUIUpdated(),
    ); 
  }

  void updateThreshold(int value) {
    plagiarismThreshold = value;
    
  }

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    dueDateDisplayController.dispose();
    return super.close();
  }
}
