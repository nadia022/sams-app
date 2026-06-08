import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';
import 'package:sams_app/features/assignments/data/model/helper/assignment_status_enum.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_attached_files_grid.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_details_header.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_stats_row.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/student/app_instructions_section.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/student/student_submission_section.dart';

class AssignmentDetailsWebStudentLayout extends StatefulWidget {
  final AssignmentModel assignment;
  final String courseId;

  const AssignmentDetailsWebStudentLayout({
    super.key,
    required this.assignment,
    required this.courseId,
  });

  @override
  State<AssignmentDetailsWebStudentLayout> createState() =>
      _AssignmentDetailsWebStudentLayoutState();
}

class _AssignmentDetailsWebStudentLayoutState
    extends State<AssignmentDetailsWebStudentLayout> {
  List<PlatformFile> myPickedFiles = [];
  @override
  Widget build(BuildContext context) {
    var width = SizeConfig.screenWidth(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: width > 940
            ? _buildDesktopLayout(context)
            : _buildTabletLayout(context),
      ),
    );
  }

  // * 1. Desktop Layout (Two Columns)
  Widget _buildDesktopLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AssignmentDetailsHeader(
          assignment: widget.assignment,
          courseId: widget.courseId,
        ),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* Left Column: Stats & Instructions (Main Content)
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AssignmentStatsRow(assignment: widget.assignment),
                  const SizedBox(height: 32),
                  AssignmentContentGrid(assignment: widget.assignment),
                  const SizedBox(height: 32),
                  _buildInstructions(),
                ],
              ),
            ),
            const SizedBox(width: 40),
            //* Right Column: Dynamic Action Area (Sidebar)
            Expanded(
              flex: 4,
              child: _buildSideContent(context),
            ),
          ],
        ),
      ],
    );
  }

  // * 2. Tablet Layout (Single Column Stacked)
  Widget _buildTabletLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AssignmentDetailsHeader(
          assignment: widget.assignment,
          courseId: widget.courseId,
        ),
        const SizedBox(height: 32),
        AssignmentStatsRow(assignment: widget.assignment),
        const SizedBox(height: 32),
        _buildSideContent(context),
        const SizedBox(height: 32),
        _buildInstructions(),
      ],
    );
  }

  // * 3. Instructions & Guidelines Section
  Widget _buildInstructions() {
    if (widget.assignment.status == AssignmentStatus.missed) {
      return const SizedBox.shrink();
    }

    return AssignmentInstructionsSection(
      title: 'Submission Instructions',
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
    );
  }

  // * 4. Side Content (Deadline Timer & Submit Actions)
  Widget _buildSideContent(BuildContext context) {
    final bool isExpired = widget.assignment.dueDate.isBefore(DateTime.now());
    final bool isSubmitted =
        widget.assignment.status == AssignmentStatus.handedIn;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isExpired && !isSubmitted) ...[
          // DeadlineTimer(endTime: assignment.dueDate),
          const SizedBox(height: 24),
        ],
       StudentSubmissionSection(assignment: widget.assignment, courseId: widget.courseId,),
      ],
    );
  }
}
