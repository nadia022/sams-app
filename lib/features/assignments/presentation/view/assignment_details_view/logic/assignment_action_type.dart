

import 'package:flutter/material.dart';

enum AssignmentActionType {
  editAssignment,
  uploadInstructions,
  addReferenceFiles,
  viewSubmissions,
  gradeSubmissions,
  viewAnalytics,
}

class AssignmentActionUIHelper {
  static String getTitle(AssignmentActionType type) {
    switch (type) {
      case AssignmentActionType.editAssignment:
        return 'Edit Details';
      case AssignmentActionType.uploadInstructions:
        return 'Upload Instructions';
      case AssignmentActionType.addReferenceFiles:
        return 'Reference Materials';
      case AssignmentActionType.viewSubmissions:
        return 'Track Submissions';
      case AssignmentActionType.gradeSubmissions:
        return 'Start Grading';
      case AssignmentActionType.viewAnalytics:
        return 'Performance Stats';
    }
  }


  static String getSubtitle(AssignmentActionType type) {
    switch (type) {
      case AssignmentActionType.editAssignment:
        return 'Change title, deadline, or basic settings';
      case AssignmentActionType.uploadInstructions:
        return 'Add PDF or documents to explain the task';
      case AssignmentActionType.addReferenceFiles:
        return 'Provide extra resources to help students';
      case AssignmentActionType.viewSubmissions:
        return 'See who submitted and who is still pending';
      case AssignmentActionType.gradeSubmissions:
        return 'Review files and assign marks to students';
      case AssignmentActionType.viewAnalytics:
        return 'View submission rates and grade distribution';
    }
  }

  
  static IconData getIcon(AssignmentActionType type) {
    switch (type) {
      case AssignmentActionType.editAssignment:
        return Icons.settings_suggest_rounded;
      case AssignmentActionType.uploadInstructions:
        return Icons.note_add_rounded;
      case AssignmentActionType.addReferenceFiles:
        return Icons.attach_file_rounded;
      case AssignmentActionType.viewSubmissions:
        return Icons.people_alt_rounded;
      case AssignmentActionType.gradeSubmissions:
        return Icons.fact_check_rounded;
      case AssignmentActionType.viewAnalytics:
        return Icons.insights_rounded;
    }
  }
}