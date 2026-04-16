import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_button.dart';
import 'package:sams_app/core/models/app_button_style_model.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_actions/widget/shared/announcement_form_section.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcement_actions/announcement_actions_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcement_actions/announcement_actions_state.dart';

class EditAndDeleteAnnouncementDialog extends StatefulWidget {
  final String announcementId;
  final String initialTitle;
  final String initialContent;

  const EditAndDeleteAnnouncementDialog({
    super.key,
    required this.announcementId,
    required this.initialTitle,
    required this.initialContent,
  });

  @override
  State<EditAndDeleteAnnouncementDialog> createState() =>
      _EditAndDeleteAnnouncementDialogState();
}

class _EditAndDeleteAnnouncementDialogState
    extends State<EditAndDeleteAnnouncementDialog> {
  // Controllers to manage and retrieve text input
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  // Key for form validation
  final _formKey = GlobalKey<FormState>();

  // Storing original values to detect if any changes were actually made
  late final String _originalTitle;
  late final String _originalContent;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the existing announcement data
    _titleController = TextEditingController(text: widget.initialTitle);
    _contentController = TextEditingController(text: widget.initialContent);

    // Keep a reference to the initial data for comparison
    _originalTitle = widget.initialTitle;
    _originalContent = widget.initialContent;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: BlocListener<AnnouncementsActionsCubit, AnnouncementsActionsState>(
        listener: (context, state) {
          // Close dialog and return a result string so the parent screen knows to refresh
          if (state is UpdateAnnouncementSuccess) {
            Navigator.pop(context, 'updated');
          } else if (state is DeleteAnnouncementSuccess) {
            Navigator.pop(context, 'deleted');
          }
          // Handle specific failure states for Update and Delete
          else if (state is UpdateAnnouncementFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errMessage),
                backgroundColor: AppColors.red,
              ),
            );
          } else if (state is DeleteAnnouncementFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errMessage),
                backgroundColor: AppColors.red,
              ),
            );
          }
        },
        child: Container(
          width: 550,
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Edit Announcement',
                  style: AppStyles.webTitleMediumSb.copyWith(
                    color: AppColors.primaryDarkHover,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 24),
                // Shared UI section containing the Title and Content text fields
                AnnouncementFormSection(
                  titleController: _titleController,
                  contentController: _contentController,
                  isEdit: true,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    // Delete Button Logic
                    Expanded(
                      child: AppButton(
                        model: AppButtonStyleModel(
                          label: 'Delete',
                          backgroundColor: Colors.redAccent,
                          onPressed: () {
                            context
                                .read<AnnouncementsActionsCubit>()
                                .deleteAnnouncement(
                                  announcementId: widget.announcementId,
                                );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Update Button Logic
                    Expanded(
                      child: AppButton(
                        model: AppButtonStyleModel(
                          label: 'Update',
                          onPressed: () {
                            // Step 1: Check if the user actually changed anything
                            bool isChanged =
                                _titleController.text != _originalTitle ||
                                _contentController.text != _originalContent;

                            if (!isChanged) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('No changes made'),
                                  backgroundColor: AppColors.red,
                                ),
                              );
                              // Navigator.pop(context);
                              return;
                            }
                            // Step 2: Validate form fields (e.g., empty check)
                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<AnnouncementsActionsCubit>()
                                  .updateAnnouncement(
                                    announcementId: widget.announcementId,
                                    title: _titleController.text,
                                    content: _contentController.text,
                                  );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
