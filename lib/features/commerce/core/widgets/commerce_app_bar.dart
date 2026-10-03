import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CommerceAppBar extends StatelessWidget {
  final String title;
  final String des;
  const CommerceAppBar({super.key, required this.title, required this.des});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => _goBack(context),
            icon: Icon(AppIcons.arrowBack),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,style: TextStyle(fontSize: 20.sp,color: context.colors.black[100]),),
              SizedBox(height: 5.h,),
               Text(des,style: TextStyle(fontSize: 14.sp,color: context.colors.black[50]),),
            ],
          ),
      
        ),
      ),
    );
  }

  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(AppRoutesName.home);
  }
}