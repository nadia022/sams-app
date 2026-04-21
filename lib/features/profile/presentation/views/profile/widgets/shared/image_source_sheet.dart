import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

//* Bottom sheet to select image source
class ImageSourceBottomSheet extends StatelessWidget {
  final Function(ImageSource) onSourceSelected;
  final Function() onRemoveSelected;
  final bool hasProfilePic;

  const ImageSourceBottomSheet({
    super.key,
    required this.onSourceSelected,
    required this.onRemoveSelected,
    required this.hasProfilePic,
  });

  @override
  Widget build(BuildContext context) {
    final bool showCamera = !kIsWeb;
    final bool showRemove = hasProfilePic;
    int visibleItemsCount = 1; // Gallery
    if (showCamera) visibleItemsCount++;
    if (showRemove) visibleItemsCount++;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'Update Profile Picture',
              style: AppStyles.mobileBodyLargeSb.copyWith(
                color: AppColors.secondaryDarkActive,
              ),
            ),
            const SizedBox(height: 20),
            // Options
            Row(
              mainAxisAlignment: visibleItemsCount == 1
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceOption(
                  context,
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  source: ImageSource.gallery,
                ),
                (showCamera)
                    ? _buildSourceOption(
                        context,
                        icon: Icons.camera_alt,
                        label: 'Camera',
                        source: ImageSource.camera,
                      )
                    : const SizedBox.shrink(),
                (showRemove)
                    ? _buildRemoveOption(
                        context,
                        icon: Icons.delete_forever_outlined,
                        label: 'Remove',
                        onTap: onRemoveSelected,
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // build source option
  Widget _buildSourceOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required ImageSource source,
  }) {
    return Column(
      children: [
        IconButton(
          icon: CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
            child: Icon(icon, color: AppColors.secondary, size: 30),
          ),
          onPressed: () {
            Navigator.pop(context);
            onSourceSelected(source);
          },
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppStyles.mobileBodySmallMd.copyWith(
            color: AppColors.secondaryDark,
          ),
        ),
      ],
    );
  }

  // build remove option
  Widget _buildRemoveOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Function() onTap,
  }) {
    return Column(
      children: [
        IconButton(
          icon: CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.redLightActive.withValues(alpha: 0.9),
            child: Icon(icon, color: AppColors.redHover, size: 30),
          ),
          onPressed: () {
            Navigator.pop(context);
            onTap();
          },
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppStyles.mobileBodySmallMd.copyWith(
            color: AppColors.redHover,
          ),
        ),
      ],
    );
  }
}
