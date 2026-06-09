import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'dart:developer';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/logic/assignment_action_type.dart';

class AssignmentNavigationHandler {
  // Main execution method
  static void execute({
    required BuildContext context,
    required AssignmentActionType action,
    required AssignmentModel assignment,
    required String courseId,
  }) {
    switch (action) {
      case AssignmentActionType.editAssignment:
        _navigateToEditAssignment(context, assignment, courseId);
        break;
      case AssignmentActionType.uploadInstructions:
        _navigateToUploadInstructions(context, assignment);
        break;
      case AssignmentActionType.viewSubmissions:
        _navigateToSubmissions(context, assignment);
        break;
      case AssignmentActionType.gradeSubmissions:
        _navigateToGrading(context, assignment);
        break;
      case AssignmentActionType.viewAnalytics:
        _navigateToAnalytics(context, assignment);
        break;
      default:
        log('Action $action not handled yet.');
    }
  }

  // --- Navigation Logic ---

  static void _navigateToEditAssignment(
    BuildContext context,
    AssignmentModel assignment,
    String courseId,
  ) {
    log('Navigating to Edit Assignment: ${assignment.id}');
    context.push(
      RoutesName.createAssignment,
      extra: {
        'courseId': courseId,
        'isEditMode': true,
        'initialData': assignment,
      },
    );
  }

  static void _navigateToUploadInstructions(
    BuildContext context,
    AssignmentModel assignment,
  ) {
    log('Navigating to Upload Instructions for: ${assignment.id}');
    context.push(
      RoutesName.createAssignment,
      extra: assignment.id,
    );
  }

  static void _navigateToSubmissions(
    BuildContext context,
    AssignmentModel assignment,
  ) {
    log('Navigating to Assignment Submissions: ${assignment.id}');
    context.push(
      RoutesName.createAssignment,
      extra: {
        'assignmentId': assignment.id,
        'assignmentTitle': assignment.title,
      },
    );
  }

  static void _navigateToGrading(
    BuildContext context,
    AssignmentModel assignment,
  ) {
    log('Navigating to Grading View for: ${assignment.id}');
    context.push(
      RoutesName.createAssignment,
      extra: assignment.id,
    );
  }

  static void _navigateToAnalytics(
    BuildContext context,
    AssignmentModel assignment,
  ) {
    log('Navigating to Analytics for: ${assignment.id}');
    context.push(
      RoutesName.createAssignment,
      extra: assignment.id,
    );
  }
}
