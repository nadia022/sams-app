import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sams_app/core/utils/mixins/cubit_message_mixin.dart';
import 'package:sams_app/core/utils/mixins/safe_emit_mixin.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';
import 'package:sams_app/features/assignments/data/repos/assignment_repo.dart';
import 'package:sams_app/features/assignments/data/repos/assignment_submission_reop.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignment_details/assignment_details_state.dart';

class AssignmentDetailsCubit extends Cubit<AssignmentDetailsState>
    with CubitMessageMixin, SafeEmitMixin {
  final AssignmentRepo assignmentRepo;
  final AssignmentSubmissionRepo repo;

  AssignmentDetailsCubit(this.assignmentRepo, this.repo)
    : super(AssignmentDetailsInitial());

  Future<void> fetchAssignmentDetails({required String assignmentId}) async {
    emit(AssignmentDetailsLoading());
    final result = await assignmentRepo.fetchAssignmentDetails(
      assignmentId: assignmentId,
    );

    result.fold(
      (failure) => emit(AssignmentDetailsFailure(failure)),
      (assignment) => emit(AssignmentDetailsSuccess(assignment)),
    );
  }

  void updateAssignmentStateLocally(AssignmentModel updatedAssignment) {
    emit(AssignmentDetailsSuccess(updatedAssignment));
  }

  Future<void> deleteSingleItem({
    required String assignmentId,
    required String itemKey,
  }) async {
    emit(DeleteAssignmentItemLoading());

    final result = await assignmentRepo.deleteAssignmentItem(
      assignmentId: assignmentId,
      itemKey: itemKey,
    );

    result.fold(
      (failure) {
        emitMessage(failure);
        emit(DeleteAssignmentItemFailure(failure));
      },
      (updatedAssignment) {
        emit(
          DeleteAssignmentItemSuccess(
            message: 'File removed successfully!',
            assignment: updatedAssignment,
          ),
        );
      },
    );
  }

  Future<void> deleteAssignment({required String assignmentId}) async {
    emit(DeleteAssignmentLoading());

    final result = await assignmentRepo.deleteAssignment(
      assignmentId: assignmentId,
    );

    result.fold(
      (failure) {
        emitMessage(failure);
        emit(DeleteAssignmentFailure(failure));
      },
      (_) {
        emit(DeleteAssignmentSuccess('Assignment deleted successfully'));
      },
    );
  }

  // ==========================================================================
  //? 5. Upload New Items Logic
  // ==========================================================================
  Future<void> uploadNewItems({
    required String assignmentId,
    required String courseId,
    required List<XFile> newFiles,
    required classworkId,
  }) async {
    if (newFiles.isEmpty) return;

    emit(AddAssignmentItemsLoading('Uploading new files...'));

    final result = await assignmentRepo.addItemsToAssignment(
      assignmentId: assignmentId,
      courseId: courseId,
      newFiles: newFiles,
      classworkId: classworkId,
    );

    result.fold(
      (failure) {
        emitMessage(failure);
        emit(AddAssignmentItemsFailure(failure));
      },
      (updatedAssignment) {
        updateAssignmentStateLocally(updatedAssignment);

        emit(
          AddAssignmentItemsSuccess(
            assignment: updatedAssignment,
            message: 'Files added successfully!',
          ),
        );
      },
    );
  }

  Future<void> submitAssignment({
    required String assignmentId,
    required String courseId,
    required List<XFile> files,
    required String classworkId,
  }) async {
    if (files.isEmpty) {
      emitMessage('Please select files to submit');
      return;
    }

    emit(StudentSubmissionLoading(message: 'Submitting your assignment...'));

    final result = await repo.submitAssignment(
      assignmentId: assignmentId,
      courseId: courseId,
      files: files,
      classworkId: classworkId,
    );

    result.fold(
      (failure) {
        emitMessage(failure);
        emit(StudentSubmissionFailure(failure));
      },
      (successMessage) {
        emit(StudentSubmissionSuccess(message: successMessage));
        emitMessage(successMessage);
      },
    );
  }

  Future<void> unsubmitAssignment({
    required String submissionId,
  }) async {
    emit(UnsubmitAssignmentLoading(message: 'Deleting files...'));

    final result = await repo.unsubmitAssignment(
      submissionId: submissionId,
    );

    result.fold(
      (failure) {
        emitMessage(failure);
        emit(UnsubmitAssignmentFailure(failure));
      },
      (updatedAssignment) {
        emit(
          UnsubmitAssignmentSuccess(
            message: 'File removed successfully!',
          ),
        );
      },
    );
  }
}
