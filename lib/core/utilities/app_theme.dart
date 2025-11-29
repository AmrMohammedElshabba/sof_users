import 'package:flutter/material.dart';
import 'package:sof_users/core/utilities/styles.dart';

import 'colors.dart';

class AppTheme {

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.kBackGround,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.kPrimary,
      primary: AppColors.kPrimary,
      secondary: AppColors.kPrimary,
      background: AppColors.kBackGround,
    ),

    appBarTheme:  AppBarTheme(

      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: AppStyles.kTextStyle18Primary,
    ),


  );
}
