
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  final AppColors colors ;
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
    appBarTheme: AppBarTheme(
      backgroundColor: colors.white,
      iconTheme: IconThemeData(color: colors.black, size: 20.w),
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
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: TextStyle(
        color: colors.black,
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: TextStyle(color: colors.grey[800], fontSize: 13.sp),
      errorStyle: TextStyle(color: colors.error, fontSize: 11.sp),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: colors.grey[900] ?? colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.r),
        borderSide: BorderSide(color:colors.grey[900] ?? colors.grey, width: 1.5.w),
      ),
      outlineBorder: BorderSide(color: colors.grey[900] ?? colors.grey, width: 1.5.w),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.r),
        borderSide: BorderSide(color: colors.error, width: 1.5.w),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.r),
        borderSide: BorderSide(color: colors.grey[900] ?? colors.grey, width: 1.5.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.r),
        borderSide: BorderSide(color: colors.pink, width: 1.5.w),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.pink,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.r),
        ),
        elevation: 0,
      ),
    ),
  );

 
}