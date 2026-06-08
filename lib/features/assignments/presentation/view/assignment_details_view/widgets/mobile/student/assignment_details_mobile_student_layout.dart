import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';
import 'package:sams_app/features/assignments/data/model/helper/assignment_status_enum.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_attached_files_list.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_details_header.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_stats_row.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/student/app_instructions_section.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/student/student_submission_section.dart';

class AssignmentDetailsMobileStudentLayout extends StatefulWidget {
  final AssignmentModel assignment;
  final String courseId;

  const AssignmentDetailsMobileStudentLayout({
    super.key,
    required this.assignment,
    required this.courseId,
  });

  @override
  State<AssignmentDetailsMobileStudentLayout> createState() =>
      _AssignmentDetailsMobileStudentLayoutState();
}

class _AssignmentDetailsMobileStudentLayoutState
    extends State<AssignmentDetailsMobileStudentLayout> {
  List<PlatformFile> myPickedFiles = [];
  @override
  Widget build(BuildContext context) {
    final bool isExpired = widget.assignment.dueDate.isBefore(DateTime.now());
    final bool isSubmitted =
        widget.assignment.status == AssignmentStatus.handedIn;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AssignmentDetailsHeader(
              assignment: widget.assignment,
              courseId: widget.courseId,
            ),
            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (!isExpired && !isSubmitted) ...[
                    // DeadlineTimer(endTime: assignment.dueDate),
                    const SizedBox(height: 24),
                  ],

                  AssignmentStatsRow(assignment: widget.assignment),
                  const SizedBox(height: 24),

                  AssignmentItemsList(assignment: widget.assignment),
                  const SizedBox(height: 24),

                  StudentSubmissionSection(
                    assignment: widget.assignment,
                    courseId: widget.courseId,
                  ),

                  const SizedBox(height: 24),

                  if (widget.assignment.status != AssignmentStatus.missed) ...[
                    AssignmentInstructionsSection(
                      title: 'Submission Guidelines',
                      instructions: (widget.assignment.enablePlagiarismCheck)
                          ? [
                              'Upload only one file.',
                              'Upload your file in DOCX or DOC format.',
                              'The total file size should not exceed 3 pages.',
                              'Make sure your work is original (Plagiarism check might be enabled).',
                              'You can edit your submission until the deadline.',
                            ]
                          : [
                              'Upload your files in PDF, PPT, PPTX, DOCX, or DOC format.',
                              'You can edit your submission until the deadline.',
                              'Please ensure a stable internet connection until the upload is complete.',
                            ],
                    ),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
