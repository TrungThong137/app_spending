import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import 'warning_one_dialog.dart';

class ShowDialog{
  dynamic showDialogNetwork(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return WarningOneDialog(
          content: 'Vui lòng kiểm tra kết nối mạng của bạn',
          // image: AppImages.icWarning,
          title: 'Mất kết nối',
          buttonName: 'Hủy',
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          onTap: () => Navigator.pop(context),
        );
      },
    );
  }

  dynamic showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        closeDialog(context);
        return const WarningOneDialog(
          // image: AppImages.icCheck,
          title: 'Thành công',
        );
      },
    );
  }

  dynamic showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        closeDialog(context);
        return const WarningOneDialog(
          // image: AppImages.icFailed,
          title: 'Thất bại',
        );
      },
    );
  }

  Future<void> closeDialog(BuildContext context) async{
    Future.delayed(
      const Duration(seconds: 1),
      () {
        Navigator.pop(context);
      } 
    );
  }
}
