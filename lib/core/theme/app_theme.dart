import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  final AppColors colors;
  final ThemeData themeData;

  AppTheme(this.colors)
      : themeData = ThemeData(
          colorScheme: ColorScheme(
            brightness: colors.brightness,
            primary: colors.pink,
            onPrimary: colors.white,
            secondary: colors.pink,
            onSecondary: colors.white,
            error: colors.error,
            onError: colors.white,
            surface: colors.white,
            onSurface: colors.black,
          ),
          brightness: colors.brightness,
          scaffoldBackgroundColor: colors.white,
          actionIconTheme: ActionIconThemeData(
            backButtonIconBuilder: (context) => Icon(
              Icons.arrow_back_ios_new,
              color: colors.black,
              size: 20.w,
            ),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: false,
            titleSpacing: 0,
            iconTheme: IconThemeData(
              color: colors.black,
              size: 28.sp,
            ),
            titleTextStyle: TextStyle(
              color: colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          textTheme: TextTheme(
            titleLarge: TextStyle(
              color: colors.black,
              fontSize: 24.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            filled: true,
            fillColor: colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            labelStyle: TextStyle(
              color: colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
            hintStyle: TextStyle(
              color: colors.grey.shade700,
              fontSize: 14.sp,
            ),
            errorStyle: TextStyle(
              color: colors.error,
              fontSize: 11.sp,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: colors.grey.shade900,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: BorderSide(
                color: colors.grey.shade900,
                width: 1.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: BorderSide(
                color: colors.pink,
                width: 1.w,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: BorderSide(
                color: colors.error,
                width: 1.w,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: BorderSide(
                color: colors.grey.shade900,
                width: 1.w,
              ),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.pink,
              padding: EdgeInsets.symmetric(
                vertical: 16.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r),
              ),
              elevation: 0,
            ),
          ),
        );
}