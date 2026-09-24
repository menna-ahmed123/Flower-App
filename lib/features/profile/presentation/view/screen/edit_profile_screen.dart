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

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.profile});

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

  final ValueNotifier<Gender?> selectedGenderNotifier = ValueNotifier<Gender?>(
    null,
  );

  @override
  void initState() {
    super.initState();

    _firstNameController = TextEditingController(
      text: widget.profile.firstName,
    );

    _lastNameController = TextEditingController(text: widget.profile.lastName);

    _emailController = TextEditingController(text: widget.profile.email ?? '');

    _phoneController = TextEditingController(
      text: widget.profile.phoneNumber ?? '',
    );

    selectedGenderNotifier.value = widget.profile.gender;

    context.read<UpdateProfileViewModel>().doEvent(
      EditProfileInitialized(profile: widget.profile),
    );

    _firstNameController.addListener(_onFirstNameChanged);
    _lastNameController.addListener(_onLastNameChanged);
    _emailController.addListener(_onEmailChanged);
    _phoneController.addListener(_onPhoneChanged);
  }

  @override
  void dispose() {
    _firstNameController.removeListener(_onFirstNameChanged);
    _lastNameController.removeListener(_onLastNameChanged);
    _emailController.removeListener(_onEmailChanged);
    _phoneController.removeListener(_onPhoneChanged);

    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    selectedGenderNotifier.dispose();

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
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(updateState.errorMessage)));
            }
          },
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              children: [
                BlocBuilder<UpdateProfileViewModel, EditProfileState>(
                  builder: (context, state) {
                    return ProfileAvatar(
                      imageFile: state.selectedImagePath != null
                          ? File(state.selectedImagePath!)
                          : null,
                      photoUrl: widget.profile.profilePictureUrl,
                      showCamera: true,
                      onTap: _pickImage,
                    );
                  },
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
                  validator: AppValidators.optionalEmailValidator,
                ),

                SizedBox(height: 12.h),

                AppTextField(
                  label: AppString.phoneNumber,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: AppValidators.optionalPhoneValidator,
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
                      AppString.changePassword,
                      style: TextStyle(
                        color: colors.pink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                ValueListenableBuilder<Gender?>(
                  valueListenable: selectedGenderNotifier,
                  builder: (context, selectedGender, child) {
                    return GenderSelector(
                      selectedGender: selectedGender,
                      onChanged: (value) {
                        selectedGenderNotifier.value = value;

                        context.read<UpdateProfileViewModel>().doEvent(
                          GenderChanged(value),
                        );
                      },
                    );
                  },
                ),

                SizedBox(height: 28.h),

                BlocBuilder<UpdateProfileViewModel, EditProfileState>(
                  builder: (context, state) {
                    final isLoading = state.updateProfileState.isLoading;

                    return AppButton(
                      text: AppString.save,
                      onPressed: state.hasChanges && !isLoading
                          ? _onUpdatePressed
                          : null,
                      isLoading: isLoading,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onFirstNameChanged() {
    context.read<UpdateProfileViewModel>().doEvent(
      FirstNameChanged(_firstNameController.text),
    );
  }

  void _onLastNameChanged() {
    context.read<UpdateProfileViewModel>().doEvent(
      LastNameChanged(_lastNameController.text),
    );
  }

  void _onEmailChanged() {
    context.read<UpdateProfileViewModel>().doEvent(
      EmailChanged(_emailController.text),
    );
  }

  void _onPhoneChanged() {
    context.read<UpdateProfileViewModel>().doEvent(
      PhoneChanged(_phoneController.text),
    );
  }

  void _pickImage() {
    context.read<UpdateProfileViewModel>().doEvent(PickProfileImageRequested());
  }

  void _onUpdatePressed() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final selectedImagePath = context
        .read<UpdateProfileViewModel>()
        .state
        .selectedImagePath;

    context.read<UpdateProfileViewModel>().doEvent(
      UpdateProfileRequested(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        gender: selectedGenderNotifier.value,
        profilePicturePath: selectedImagePath,
      ),
    );
  }
}
