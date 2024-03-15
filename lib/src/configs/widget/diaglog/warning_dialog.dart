import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/constants.dart';
import '../button/button.dart';
import '../button/button_outline.dart';
import '../form_field/app_form_field.dart';
import '../text/paragraph.dart';

class WarningDialog extends StatelessWidget {
  const WarningDialog({
    Key? key,
    this.content,
    this.image,
    this.title,
    this.leftButtonName,
    this.color,
    this.colorNameLeft,
    this.rightButtonName,
    this.onTapLeft,
    this.onTapRight,
    this.isForm = false,
    this.controller,
    this.isWaning=false,
  }) : super(key: key);
  final String? content;
  final String? title;
  final String? leftButtonName;
  final String? rightButtonName;
  final String? image;
  final Color? color;
  final Color? colorNameLeft;
  final Function()? onTapLeft;
  final Function()? onTapRight;
  final bool isForm;
  final TextEditingController? controller;
  final bool isWaning;

  dynamic dialogContent(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image != null)
              isWaning ? SvgPicture.asset(
                image ?? '',
                width: 100,
                height: 100,
              )
              :CircleAvatar(
                backgroundColor: AppColors.COLOR_WHITE,
                radius: 35,
                child: SvgPicture.asset(
                  image ?? '',
                ),
              ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeToPadding.sizeMedium,
              ),
              child: Paragraph(
                textAlign: TextAlign.center,
                content: title,
                style: STYLE_BIG.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            if (content != null)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeToPadding.sizeSmall,
                  vertical: SizeToPadding.sizeLarge,
                ),
                child: Paragraph(
                  textAlign: TextAlign.center,
                  content: content ?? '',
                  style: STYLE_MEDIUM,
                ),
              ),
            if (!isForm) const SizedBox(height: 10),
            if (isForm)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppFormField(
                  keyboardType: TextInputType.phone,
                  textEditingController: controller,
                  hintText: 'Nhập số điện thoại',
                ),
              ),
            SizedBox(height: content != null ? 10 : 30),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 10),
                    child: AppOutlineButton(
                      content: leftButtonName,
                      onTap: onTapLeft,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 15),
                    child: AppButton(
                      enableButton: true,
                      content: rightButtonName,
                      onTap: onTapRight,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
