import 'dart:io';

import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/helpers/app_validators.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flower_app/core/widgets/app_text_field.dart';
import 'package:flower_app/features/profile/domain/entities/gender.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/gender_selector.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/profile_avatar.dart';
import 'package:flower_app/features/profile/presentation/view_model/edit_profile_event.dart';
import 'package:flower_app/features/profile/presentation/view_model/edit_profile_state.dart';
import 'package:flower_app/features/profile/presentation/view_model/update_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    required this.profile,
  });

  final ProfileEntity profile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  String? _selectedGender;

  XFile? selectedImage;

  @override
  void initState() {
    super.initState();

    _firstNameController = TextEditingController(
      text: widget.profile.firstName,
    );

    _lastNameController = TextEditingController(
      text: widget.profile.lastName,
    );

    _emailController = TextEditingController(
      text: widget.profile.email ?? '',
    );

    _phoneController = TextEditingController(
      text: widget.profile.phoneNumber ?? '',
    );

    _selectedGender = widget.profile.gender?.name;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.myProfile),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Badge(
              backgroundColor: colors.pink,
              label: const Text('3'),
              child: Icon(
                Icons.notifications_none,
                color: colors.black,
                size: 24.w,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocListener<UpdateProfileViewModel, EditProfileState>(
          listener: (context, state) {
            final updateState = state.updateProfileState;

            if (updateState.data != null) {
              context.pop();
            } else if (updateState.errorMessage.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(updateState.errorMessage),
                ),
              );
            }
          },
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              children: [
                ProfileAvatar(
                  imageFile: selectedImage != null
                      ? File(selectedImage!.path)
                      : null,
                  photoUrl: widget.profile.profilePictureUrl,
                  showCamera: true,
                  onTap: pickImage,
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: AppString.firstName,
                        controller: _firstNameController,
                        validator: (value) {
                          return AppValidators.requiredField(
                            value,
                            field: AppString.firstName,
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: AppTextField(
                        label: AppString.lastName,
                        controller: _lastNameController,
                        validator: (value) {
                          return AppValidators.requiredField(
                            value,
                            field: AppString.lastName,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                AppTextField(
                  label: AppString.email,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return null;
                    }

                    return AppValidators.emailValidator(value);
                  },
                ),
                SizedBox(height: 12.h),
                AppTextField(
                  label: AppString.phoneNumber,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return null;
                    }

                    return AppValidators.phoneValidator(value);
                  },
                ),
                SizedBox(height: 12.h),
                AppTextField(
                  label: AppString.password,
                  readOnly: true,
                  initialValue: '••••••••',
                  suffixIcon: TextButton(
                    onPressed: () {
                      // TODO: navigate to change-password flow.
                    },
                    child: Text(
                      "AppString.ch",
                      style: TextStyle(
                        color: colors.pink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                GenderSelector(
                  selectedGender: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                SizedBox(height: 28.h),
                AppButton(
                  text: "AppString.aboutUs",
                  onPressed: _onUpdatePressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    final XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  void _onUpdatePressed() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<UpdateProfileViewModel>().doEvent(
      UpdateProfileRequested(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        gender: Gender.fromString(_selectedGender),
        profilePicturePath: selectedImage?.path,
      ),
    );
  }
}

