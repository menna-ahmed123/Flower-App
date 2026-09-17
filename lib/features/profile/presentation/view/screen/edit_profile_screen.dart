<<<<<<< HEAD
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/helpers/app_validators.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flower_app/core/widgets/app_text_field.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/gender_selector.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/profile_avatar_picker.dart';
import 'package:flower_app/features/profile/presentation/view_model/update_profile_view_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

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

  @override
  void initState() {
    super.initState();

    final profileViewModel = context.read<UpdateProfileViewModel>();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
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
        title: Text(
          AppString.myProfile,
        ),
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
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            children: [
              ProfileAvatarPicker(
                onTap: () {
                  // TODO: image picker logic
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
                  "  AppString.change",
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
                text: "AppString.update",
                onPressed: _onUpdatePressed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onUpdatePressed() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // TODO: call UpdateProfileUseCase / Cubit with the form data.
  }
}

=======
import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Placeholder destination for the Profile pen icon; the real Edit Profile
/// feature (form, validation, update API) is implemented separately.
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppString.editProfile,
        onBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AppRoutesName.profile);
          }
        },
      ),
      body: const SafeArea(child: SizedBox.shrink()),
    );
  }
}
>>>>>>> origin/feature/profile-screen-
