import 'package:flutter/material.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/classwork_item_model.dart';

@immutable
sealed class CreateAssignmentState {}

final class CreateAssignmentInitial extends CreateAssignmentState {}

final class CreateAssignmentLoading extends CreateAssignmentState {
  final bool isUploadingFiles;
  CreateAssignmentLoading({required this.isUploadingFiles});
}

final class CreateAssignmentSuccess extends CreateAssignmentState {
  final AssignmentModel assignment;
  final String message;
  CreateAssignmentSuccess({required this.assignment, required this.message});
}

final class CreateAssignmentFailure extends CreateAssignmentState {
  final String errMessage;
  CreateAssignmentFailure(this.errMessage);
}


// inside create_assignment_state.dart

// ── UI States ──
final class CreateAssignmentUIUpdated extends CreateAssignmentState {}

// ── Available Classworks (For Picker) ──
final class AvailableClassworksLoading extends CreateAssignmentState {}

final class AvailableClassworksLoaded extends CreateAssignmentState {
  final List<ClassworkItemModel> classworks;
   AvailableClassworksLoaded(this.classworks);
}

final class AvailableClassworksFailure extends CreateAssignmentState {
  final String message;
   AvailableClassworksFailure(this.message);
}

// ── Create New Classwork (For Dialog) ──
final class CreateClassworkLoading extends CreateAssignmentState {}

final class CreateClassworkSuccess extends CreateAssignmentState {
  final String message;
   CreateClassworkSuccess(this.message);
}

final class CreateClassworkFailure extends CreateAssignmentState {
  final String message;
   CreateClassworkFailure(this.message);
}
