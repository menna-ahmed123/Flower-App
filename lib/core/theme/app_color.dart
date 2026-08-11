import 'package:flutter/material.dart';

abstract class AppColors {
  MaterialColor get grey;
  MaterialColor get pink;
  MaterialColor get black;

  Color get error;
  Color get success;
  Color get lightPink;
  Color get white;
  Color get disabledButton;
  Color get shadow;
  Color get unselectedAnswer;
  Color get green;
  Brightness get brightness;
}

class LightThemeColor implements AppColors {
  @override
  Brightness get brightness => Brightness.light;
  @override
  Color get disabledButton => Color(0xff5d6063);
  @override
  Color get error => Color(0xFFD32F2F);
  @override
  MaterialColor get grey => MaterialColor(0xffF9F9F9, const <int, Color>{
    50: Color(0xFFFDFDFD),
    100: Color(0xFFFDFDFD),
    200: Color(0xFFFCFCFC),
    300: Color(0xFFFBFBFB),
    400: Color(0xFFFAFAFA),
    500: Color(0xFFF9F9F9),
    600: Color(0xFFBDBDBD),
    700: Color(0xFF969696),
    800: Color(0xFF707070),
    900: Color(0xFF535353),
    950: Color(0xFF232323),
  });
  @override
  Color get lightPink => Color(0xfff0b4cd);
  @override
  MaterialColor get black => MaterialColor(0xff0c1015, const <int, Color>{
    10: Color(0xFFcecfd0),
    20: Color(0xFFaeafb1),
    30: Color(0xFF86888a),
    40: Color(0xFF5d6063),
    50: Color(0xFF34383c),
    60: Color(0xFF0a0d12),
    70: Color(0xFF080b0e),
    80: Color(0xFF06080b),
    90: Color(0xFF040507),
    100: Color(0xFF020304),
  });
  @override
  MaterialColor get pink => MaterialColor(0xFFD21E6A, <int, Color>{
    50: Color(0xFFF4DBE4),
    100: Color(0xFFE9B8CA),
    200: Color(0xFFDE96B1),
    300: Color(0xFFD37397),
    400: Color(0xFFC8507E),
    500: Color(0xFFCD2A6A),
    600: Color(0xFFA21F53),
    700: Color(0xFF7B183F),
    800: Color(0xFF54102B),
    900: Color(0xFF3E0C1F),
    950: Color(0xFF290815),
  });
  @override
  Color get shadow => Color(0xFFABBCDE);
  @override
  Color get success => Color(0xffe1699c);
  @override
  Color get unselectedAnswer => Color(0xFFD32F2F);
  @override
  Color get white => Color(0xfffefefe);
  @override
  Color get green => Color(0xFF28A745);
}

class DarkThemeColor implements AppColors {
  @override
  Brightness get brightness => Brightness.dark;
  @override
  Color get disabledButton => Color(0xff5d6063);
  @override
  Color get error => Color(0xFFD32F2F);
  @override
  MaterialColor get grey => MaterialColor(0xffF9F9F9, const <int, Color>{
    50: Color(0xFFFDFDFD),
    100: Color(0xFFFDFDFD),
    200: Color(0xFFFCFCFC),
    300: Color(0xFFFBFBFB),
    400: Color(0xFFFAFAFA),
    500: Color(0xFFF9F9F9),
    600: Color(0xFFBDBDBD),
    700: Color(0xFF969696),
    800: Color(0xFF707070),
    900: Color(0xFF535353),
    950: Color(0xFF232323),
  });
  @override
  Color get lightPink => Color(0xfff0b4cd);
  @override
  MaterialColor get black => MaterialColor(0xff0c1015, const <int, Color>{
    10: Color(0xFFcecfd0),
    20: Color(0xFFaeafb1),
    30: Color(0xFF86888a),
    40: Color(0xFF5d6063),
    50: Color(0xFF34383c),
    60: Color(0xFF0a0d12),
    70: Color(0xFF080b0e),
    80: Color(0xFF06080b),
    90: Color(0xFF040507),
    100: Color(0xFF020304),
  });
  @override
  MaterialColor get pink => MaterialColor(0xFFD21E6A, <int, Color>{
    50: Color(0xFFF4DBE4),
    100: Color(0xFFE9B8CA),
    200: Color(0xFFDE96B1),
    300: Color(0xFFD37397),
    400: Color(0xFFC8507E),
    500: Color(0xFFCD2A6A),
    600: Color(0xFFA21F53),
    700: Color(0xFF7B183F),
    800: Color(0xFF54102B),
    900: Color(0xFF3E0C1F),
    950: Color(0xFF290815),
  });
  @override
  Color get shadow => Color(0xFFABBCDE);
  @override
  Color get success => Color(0xffe1699c);
  @override
  Color get unselectedAnswer => Color(0xFFD32F2F);
  @override
  Color get white => Color(0xfffefefe);
  @override
  Color get green => Color(0xFF28A745);
}
final lightThemeColors = LightThemeColor();
final darkThemeColors = DarkThemeColor();
extension ThemeColors on BuildContext {
  AppColors get colors =>
      Theme.of(this).brightness == Brightness.light
          ? lightThemeColors
          : darkThemeColors;
}
//  color: context.appColors.error,