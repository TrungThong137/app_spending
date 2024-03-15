import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../configs/constants/constants.dart';
import '../../../configs/widget/button/button.dart';
import '../../../configs/widget/text/paragraph.dart';

class BottomSheetMonth {
  const BottomSheetMonth({
    required this.context,
    required this.dateTime,
    this.onUpdateDateTime,
    this.onTapButton,
    this.mode= CupertinoDatePickerMode.dateAndTime,
    this.title
  });

  final BuildContext context;
  final DateTime dateTime;
  final Function(dynamic value)? onUpdateDateTime;
  final CupertinoDatePickerMode mode;
  final Function()? onTapButton; 
  final String? title;

  Widget buildTitleSelectTime() {
    return Padding(
      padding: EdgeInsets.all(SizeToPadding.sizeMedium),
      child: Paragraph(
        content: title??'',
        style: STYLE_MEDIUM.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildTimeSelect() {
    return SizedBox(
      height: 180,
      child: CupertinoDatePicker(
        initialDateTime: dateTime,
        mode: mode,
        use24hFormat: true,
        onDateTimeChanged: (value) {
          onUpdateDateTime!(value);
        },
      ),
    );
  }

  Widget buildButtonSelectTime() {
    return Padding(
      padding: EdgeInsets.all(SizeToPadding.sizeMedium),
      child: AppButton(
        content: 'Xong',
        enableButton: true,
        onTap: ()  {
          onTapButton!();
        },
      ),
    );
  }

  dynamic showSelectTime() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height / 2.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitleSelectTime(),
            buildTimeSelect(),
            buildButtonSelectTime(),
          ],
        ),
      ),
    );
  }
}