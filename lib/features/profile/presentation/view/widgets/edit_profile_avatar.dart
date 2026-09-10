import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

/// Avatar with a camera badge; taps open the gallery per backend upload support.
class EditProfileAvatar extends StatelessWidget {
  const EditProfileAvatar({
    super.key,
    required this.photoUrl,
    required this.pickedImage,
    required this.onImagePicked,
  });

  final String? photoUrl;
  final File? pickedImage;
  final ValueChanged<File> onImagePicked;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      onImagePicked(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 48.r,
            backgroundColor: colors.lightPink,
            child: ClipOval(child: _buildImage(colors)),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: CircleAvatar(
              radius: 14.r,
              backgroundColor: colors.pink,
              child: Icon(AppIcons.camera, size: 16.w, color: colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(AppColors colors) {
    if (pickedImage != null) {
      return Image.file(
        pickedImage!,
        width: 96.w,
        height: 96.w,
        fit: BoxFit.cover,
      );
    }
    if (photoUrl == null || photoUrl!.isEmpty) {
      return Icon(AppIcons.person, size: 48.w, color: colors.pink);
    }
    return CachedNetworkImage(
      imageUrl: photoUrl!,
      width: 96.w,
      height: 96.w,
      fit: BoxFit.cover,
    );
  }
}
