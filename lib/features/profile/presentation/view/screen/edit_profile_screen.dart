import 'dart:io';

import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/helpers/app_validators.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flower_app/features/auth/core/presentation/view_model/auth_cubit.dart';
import 'package:flower_app/features/auth/core/presentation/view_model/auth_event.dart';
import 'package:flower_app/features/auth/login/presentation/view/pages/widgets/custom_app_bar.dart';
import 'package:flower_app/features/auth/login/presentation/view/pages/widgets/custom_text_feild.dart';
import 'package:flower_app/features/auth/register/domain/entity/gender.dart';
import 'package:flower_app/features/auth/register/presentation/widgets/register_gender_selector.dart';
import 'package:flower_app/features/profile/domain/entities/update_profile_params.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/edit_profile_avatar.dart';
import 'package:flower_app/features/profile/presentation/view_model/profile_event.dart';
import 'package:flower_app/features/profile/presentation/view_model/profile_state.dart';
import 'package:flower_app/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Edits the fields the backend actually accepts on `PUT /identity/users/me/profile`.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.profile});

  final ProfileEntity profile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late Gender _gender;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.profile.fullName);
    _emailController = TextEditingController(text: widget.profile.email ?? '');
    _phoneController = TextEditingController(
      text: widget.profile.phoneNumber ?? '',
    );
    _gender = widget.profile.gender ?? Gender.female;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onImagePicked(File file) => setState(() => _pickedImage = file);

  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final params = UpdateProfileParams(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      gender: _gender.apiValue,
      profilePicture: _pickedImage,
    );

    context.read<ProfileViewModel>().doEvent(ProfileUpdateRequested(params));
  }

  void _onChangePasswordTap(BuildContext context) {
    context.push(AppRoutesName.forgetPassword);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileViewModel, ProfileState>(
      listenWhen: (previous, current) =>
          previous.updateState != current.updateState,
      listener: (context, state) => _handleUpdateState(context, state),
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppString.editProfile,
          onBack: () => context.pop(),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  EditProfileAvatar(
                    // profilePictureUrl is relative per the API contract; resolve it like ProfileDisplayData does.
                    photoUrl: ApiEndpoints.mediaUrl(widget.profile.profilePictureUrl),
                    pickedImage: _pickedImage,
                    onImagePicked: _onImagePicked,
                  ),
                  SizedBox(height: 24.h),
                  CustomTextField(
                    label: AppString.fullName,
                    hint: AppString.fullName,
                    controller: _fullNameController,
                    validator: (value) =>
                        AppValidators.requiredField(value, field: AppString.fullName),
                  ),
                  CustomTextField(
                    label: AppString.email,
                    hint: AppString.email,
                    controller: _emailController,
                    validator: AppValidators.emailValidator,
                  ),
                  CustomTextField(
                    label: AppString.phoneNumber,
                    hint: AppString.phoneNumber,
                    controller: _phoneController,
                    validator: AppValidators.phoneValidator,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RegisterGenderSelector(
                        value: _gender,
                        enabled: true,
                        onChanged: (value) => setState(() => _gender = value),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => _onChangePasswordTap(context),
                        child: Text(AppString.changePassword),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  BlocBuilder<ProfileViewModel, ProfileState>(
                    buildWhen: (previous, current) =>
                        previous.updateState != current.updateState,
                    builder: (context, state) {
                      return AppButton(
                        text: AppString.update,
                        isLoading: state.updateState.isLoading,
                        onPressed: () => _onSubmit(context),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleUpdateState(BuildContext context, ProfileState state) {
    final updateState = state.updateState;
    if (updateState.isLoading) {
      return;
    }
    if (updateState.errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(updateState.errorMessage)),
      );
      return;
    }
    if (updateState.data == null) {
      return;
    }

    if (state.requiresReauth) {
      _handleEmailChangedLogout(context);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppString.profileUpdatedSuccess)),
    );
    context.pop();
  }

  // Email changes invalidate the backend session, so force a re-login
  // through the existing AuthCubit instead of leaving a stale session.
  Future<void> _handleEmailChangedLogout(BuildContext context) async {
    final authCubit = context.read<AuthCubit>();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppString.emailChangedSignInAgain)),
    );

    await authCubit.doEvent(const AuthLogoutRequested());
    if (!mounted) {
      return;
    }
    context.go(AppRoutesName.login);
  }
}
