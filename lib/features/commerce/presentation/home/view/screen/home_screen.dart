import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: [
          ElevatedButton(
            onPressed: () {
              context.push(AppRoutesName.occasion);
            },
            child: Text("ViEW ALL",style: TextStyle(color: context.colors.black[50]),),
          ),
          ElevatedButton(
        onPressed: () {
          context.push(AppRoutesName.bestSeller);
        },
        child: Text("ViEW ALL",style: TextStyle(color: context.colors.black[50]),),
      ),
        ],
      )
      ,
       
      );
  }
}
