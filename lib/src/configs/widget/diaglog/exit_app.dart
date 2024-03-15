import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/constants.dart';
import 'dialog.dart';

Future<bool> showExitPopup(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (_) {
        return WarningDialog(
          // image: AppImages.icWarning,
          title: 'Exit the application',
          content: 'Do you want to exit the application?',
          leftButtonName: 'Cancel',
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: 'Confirm',
          isWaning: true,
          onTapLeft: () {
            Navigator.pop(context);
          },
          onTapRight: () {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(0);
            }
          },
        );
      },
    )??false;
  }