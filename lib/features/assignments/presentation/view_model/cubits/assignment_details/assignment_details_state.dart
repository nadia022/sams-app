import 'package:flutter/material.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';

@immutable
abstract class AssignmentDetailsState {}

final class AssignmentDetailsInitial extends AssignmentDetailsState {}

// ==========================================================================
//? --- 1. Fetch Details Section ---
// ==========================================================================

final class AssignmentDetailsLoading extends AssignmentDetailsState {}

final class AssignmentDetailsSuccess extends AssignmentDetailsState {
  final AssignmentModel assignment;
  AssignmentDetailsSuccess(this.assignment);
}

final class AssignmentDetailsFailure extends AssignmentDetailsState {
  final String errMessage;
  AssignmentDetailsFailure(this.errMessage);
}

// ==========================================================================
//? --- 2. Action States Base (CRUD Operations) ---
// ==========================================================================

sealed class AssignmentActionState extends AssignmentDetailsState {}

// --- Delete Single Item States ---
final class DeleteAssignmentItemLoading extends AssignmentActionState {}

final class DeleteAssignmentItemSuccess extends AssignmentActionState {
  final AssignmentModel assignment;
  final String message;
  DeleteAssignmentItemSuccess({required this.assignment, required this.message});
}

final class DeleteAssignmentItemFailure extends AssignmentActionState {
  final String errMessage;
  DeleteAssignmentItemFailure(this.errMessage);
}

// --- Delete Entire Assignment States ---
final class DeleteAssignmentLoading extends AssignmentActionState {}

final class DeleteAssignmentSuccess extends AssignmentActionState {
  final String message;
  DeleteAssignmentSuccess(this.message);
}

final class DeleteAssignmentFailure extends AssignmentActionState {
  final String errMessage;
  DeleteAssignmentFailure(this.errMessage);
}

// --- Add/Upload New Items States ---
final class AddAssignmentItemsLoading extends AssignmentActionState {
  final String message;
  AddAssignmentItemsLoading([this.message = 'Uploading files...']);
}

final class AddAssignmentItemsSuccess extends AssignmentActionState {
  final AssignmentModel assignment;
  final String message;
  AddAssignmentItemsSuccess({required this.assignment, required this.message});
}

final class AddAssignmentItemsFailure extends AssignmentActionState {
  final String errMessage;
  AddAssignmentItemsFailure(this.errMessage);
}

// =================  Student Submission =================

sealed class StudentSubmissionState extends AssignmentActionState {}

final class StudentSubmissionLoading extends StudentSubmissionState {
  final String message;
  StudentSubmissionLoading({required this.message});
}

final class StudentSubmissionSuccess extends StudentSubmissionState {
  final String message;
  StudentSubmissionSuccess({required this.message});
}

final class StudentSubmissionFailure extends StudentSubmissionState {
  final String errMessage;
  StudentSubmissionFailure(this.errMessage);
}

final class UnsubmitAssignmentLoading extends StudentSubmissionState {
  final String message;
  UnsubmitAssignmentLoading({required this.message});
}

final class UnsubmitAssignmentSuccess extends StudentSubmissionState {
  final String message;
  UnsubmitAssignmentSuccess({required this.message});
}

final class UnsubmitAssignmentFailure extends StudentSubmissionState {
  final String errMessage;
  UnsubmitAssignmentFailure(this.errMessage);
}
