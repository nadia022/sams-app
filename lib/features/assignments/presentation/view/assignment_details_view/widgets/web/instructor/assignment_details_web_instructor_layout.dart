import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sams_app/core/utils/assets/app_lottie.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';
import 'package:sams_app/features/assignments/data/model/helper/assignment_status_enum.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_attached_files_grid.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_details_header.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_details_schedule_card.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_stats_row.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/instructor/assignment_actions_list.dart';

class AssignmentDetailsWebInstructorLayout extends StatelessWidget {
  final AssignmentModel assignment;
  final String courseId;

  const AssignmentDetailsWebInstructorLayout({
    super.key,
    required this.assignment,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    var width = SizeConfig.screenWidth(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * 1. Header (Full Width)
            AssignmentDetailsHeader(
              assignment: assignment,
              courseId: courseId,
            ),
            const SizedBox(height: 32),

            // * 2. Adaptive Content (Desktop vs Tablet)
            width > 990 ? _buildDesktopContent() : _buildTabletContent(),
          ],
        ),
      ),
    );
  }

  // * Desktop Layout (Two Columns: Main Info | Sidebar Actions)
  Widget _buildDesktopContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Schedule & Status Banner
        Expanded(
          flex: 6,
          child: _buildMainBody(),
        ),
        const SizedBox(width: 40),
        // Right Column: Action List Container
        Expanded(
          flex: 4,
          child: _isDraft()
              ? Center(child: Lottie.asset(AppLottie.empty, height: 250))
              : _buildSideContent(),
        ),
      ],
    );
  }

  // * Tablet Layout (Single Column)
  Widget _buildTabletContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainBody(),
        const SizedBox(height: 32),
        _isDraft() ? const SizedBox() : _buildSideContent(),
      ],
    );
  }

  // * Main Body Content (Schedule Card & Status Banner)
  Widget _buildMainBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AssignmentDetailsScheduleCard(assignment: assignment),
        const SizedBox(height: 32),
        // AssignmentContextualBanner(assignment: assignment),

        AssignmentStatsRow(assignment: assignment),

        const SizedBox(height: 32),
        AssignmentContentGrid(assignment: assignment),
      ],
    );
  }

  // * Sidebar Container for Instructor Actions
  Widget _buildSideContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primaryLightActive),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AssignmentActionsList(
        assignment: assignment,
        courseId: courseId,
      ),
    );
  }

  bool _isDraft() {
    return assignment.status == AssignmentStatus.assigned &&
        assignment.points == 0;
  }
}
