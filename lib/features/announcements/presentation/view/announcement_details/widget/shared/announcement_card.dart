import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sams_app/core/utils/assets/app_icons.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/announcements/data/model/announcement_details_model.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_actions/widget/shared/edit_and_delete_announcement_dialog.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcement_actions/announcement_actions_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_state.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnnouncementsFetchCubit, AnnouncementsFetchState>(
      builder: (context, state) {
        //  Handling loading state using a boolean
        final bool isLoading = state is AnnouncementDetailsFetchLoading;
       
        //  Handling failure state
        if (state is AnnouncementDetailsFetchFailure) {
          return Center(child: Text(state.errMessage));
        }
        final announcementDetails = (state is AnnouncementFetchDetailsSuccess)
            ? state.announcementDetails
            : null;

        if (announcementDetails == null && isLoading == false) {
          return const SizedBox();
        }
        return Skeletonizer(
          enabled: isLoading,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primaryDarkHover.withOpacity(0.10),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryDarkHover.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.campaign_outlined,
                        color: AppColors.primaryDarkHover,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        isLoading
                            ? 'Loading Announcement Title'
                            : announcementDetails!.title,
                        style: AppStyles.web30Regular.copyWith(
                          color: AppColors.primaryDarkHover,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    //  Hide the Edit button during loading
                    if (!isLoading)
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => _handleEditAndDeleteAction(
                          context,
                          announcementDetails!,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: SvgPicture.asset(
                            AppIcons.iconsEditMaterial,
                            width: 20,
                            height: 20,
                            colorFilter: ColorFilter.mode(
                              AppColors.primaryDarkHover.withOpacity(0.7),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 20),
                const Divider(height: 1),
                const SizedBox(height: 20),

                // Content
                Text(
                  isLoading
                      ? 'This is a dummy content for the announcement that spans multiple lines to show the skeleton effect properly.'
                      : announcementDetails!.content,
                  style: AppStyles.web16Medium.copyWith(
                    color: AppColors.primaryDarker,
                    height: 1.75,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Refactored method to handle the logic for updating or deleting an announcement
  Future<void> _handleEditAndDeleteAction(
    BuildContext context,
    AnnouncementDetailsModel announcementDetails,
  ) async {
    // Obtain Cubits before opening the dialog to maintain reference
    final fetchCubit = context.read<AnnouncementsFetchCubit>();
    final actionsCubit = context.read<AnnouncementsActionsCubit>();

    // Open the Action Dialog and wait for the result ('updated' or 'deleted')
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: fetchCubit),
          BlocProvider.value(value: actionsCubit),
        ],
        child: EditAndDeleteAnnouncementDialog(
          announcementId: announcementDetails.id,
          initialTitle: announcementDetails.title,
          initialContent: announcementDetails.content,
        ),
      ),
    );

    // Guard clause: ensure context is still valid and we have a result
    if (!context.mounted || result == null) return;

    // Get CourseID for list synchronization after update/delete
    final courseId = GoRouterState.of(context).pathParameters['courseId'];

    if (result == 'updated') {
      _onUpdateSuccess(context, fetchCubit, announcementDetails.id, courseId);
    } else if (result == 'deleted') {
      _onDeleteSuccess(context, courseId);
    }
  }

  /// Private helper to handle post-update UI logic
  void _onUpdateSuccess(
    BuildContext context,
    AnnouncementsFetchCubit cubit,
    String id,
    String? courseId,
  ) {
    // Refresh the details silently without showing loading indicator again
    cubit.fetchAnnouncementDetails(announcementId: id, showLoading: false);

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Announcement updated successfully'),
        backgroundColor: AppColors.green,
      ),
    );

    // Refresh all related lists if CourseID exists
    if (courseId != null) {
      AnnouncementsFetchCubit.refreshAllLists(courseId);
    }
  }

  /// Private helper to handle post-deletion UI logic
  void _onDeleteSuccess(BuildContext context, String? courseId) {
    if (courseId != null) {
      AnnouncementsFetchCubit.refreshAllLists(courseId);
    }
    // Navigate back to the previous screen since the item no longer exists
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Announcement deleted successfully'),
        backgroundColor: AppColors.green,
      ),
    );
  }
}
