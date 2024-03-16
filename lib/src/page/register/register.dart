// ignore_for_file: deprecated_member_use

import 'package:app_spending/src/configs/widget/button/button.dart';
import 'package:app_spending/src/page/login/login.dart';
import 'package:app_spending/src/page/register/components/clipper.dart';
import 'package:app_spending/src/resource/firebase/authentication_server.dart';
import 'package:app_spending/src/utils/app_valid.dart';
import 'package:flutter/material.dart';

import '../../configs/constants/constants.dart';
import '../../configs/widget/diaglog/dialog.dart';
import '../../configs/widget/form_field/app_form_field.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../configs/widget/text/paragraph.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController mailController;
  late TextEditingController passController;
  late TextEditingController cnfPassController;
  late TextEditingController fullNameController;

  bool isEnableButton = false;
  bool isScroll = false;

  String? messagePass;
  String? messageMail;
  String? messageCnfPass;
  String? messageFullName;

  late List<FocusNode> listFocus;

  @override
  void initState() {
    super.initState();
    listFocus = List.generate(4, (index) => FocusNode());
    setScroll();
    fullNameController = TextEditingController();
    cnfPassController = TextEditingController();
    mailController = TextEditingController();
    passController = TextEditingController();
  }

  void setScroll() {
    for (var node in listFocus) {
      node.addListener(() {
        isScroll = listFocus.any((focus) => focus.hasFocus);
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: SafeArea(
        top: true,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.BLACK_200,
          body: SingleChildScrollView(
            physics: isScroll
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: double.maxFinite,
              child: Column(
                children: [
                  buildHeaderRegister(),
                  buildFormRegister(),
                  Expanded(
                      child: Container(
                    color: AppColors.COLOR_WHITE,
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButtonBackHeader() {
    return TextButton(
        onPressed: () => Navigator.pop(context),
        child: Row(
          children: [
            const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.COLOR_WHITE,
              size: 18,
            ),
            Paragraph(
              content: 'Back',
              style: STYLE_MEDIUM.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.COLOR_WHITE,
              ),
            )
          ],
        ));
  }

  Widget buildContentHeaderRegister() {
    return Column(
      children: [
        buildButtonBackHeader(),
        Paragraph(
          content: 'Register',
          style: STYLE_VERY_BIG.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 40,
            color: AppColors.COLOR_WHITE,
          ),
        ),
        Paragraph(
          content: 'Start organizing spending',
          style: STYLE_VERY_BIG.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 30,
            color: AppColors.COLOR_WHITE,
          ),
        )
      ],
    );
  }

  Widget buildHeaderRegister() {
    return Container(
      color: AppColors.COLOR_WHITE,
      height: 300,
      child: ClipPath(
        clipper: HeaderClipper(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(color: AppColors.COLOR_PINK_200),
            ),
            buildContentHeaderRegister(),
          ],
        ),
      ),
    );
  }

  Widget buildFormRegister() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 20, horizontal: SpaceBox.sizeMedium),
          child: Column(
            children: [
              buildFieldFullName(),
              buildFieldMail(),
              buildFieldPass(),
              buildFieldPassConfirm(),
              buildRegisterButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFieldMail() {
    return AppFormField(
      focusNode: listFocus[0],
      labelText: 'Email',
      hintText: 'Enter email',
      textEditingController: mailController,
      onChanged: (value) {
        validMail(value);
        onEnableRegister();
      },
      validator: messageMail ?? '',
    );
  }

  Widget buildFieldFullName() {
    return AppFormField(
      focusNode: listFocus[1],
      labelText: 'Name',
      hintText: 'Enter name',
      textEditingController: fullNameController,
      onChanged: (value) {
        validName(value);
        onEnableRegister();
      },
      validator: messageFullName ?? '',
    );
  }

  Widget buildFieldPass() {
    return AppFormField(
      focusNode: listFocus[2],
      labelText: 'Password',
      hintText: 'Enter password',
      textEditingController: passController,
      obscureText: true,
      onChanged: (value) {
        validPass(value, cnfPassController.text);
        onEnableRegister();
      },
      validator: messagePass ?? '',
    );
  }

  Widget buildFieldPassConfirm() {
    return AppFormField(
      focusNode: listFocus[3],
      labelText: 'Confirm password',
      hintText: 'Confirm password',
      textEditingController: cnfPassController,
      obscureText: true,
      onChanged: (value) {
        validConfirmPass(passController.text, value);
        onEnableRegister();
      },
      validator: messageCnfPass ?? '',
    );
  }

  Widget buildRegisterButton() {
    return AppButton(
      content: 'Create Account',
      enableButton: isEnableButton,
      onTap: () => onRegister(),
    );
  }

  void goToLogin() async {
    await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ));
  }

  void onRegister() {
    LoadingDialog.showLoadingDialog(context);
    Authentication().signUp(
        mailController.text.toString().trim(),
        passController.text.toString().trim(),
        fullNameController.text.toString().trim(), () {
      LoadingDialog.hideLoadingDialog(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Registered successfully"),
      ));
      goToLogin();
    }, (msg) {
      LoadingDialog.hideLoadingDialog(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
      ));
    });
  }

  void validMail(String? value) {
    final result = AppValid.validateEmail(value);
    if (result != null) {
      messageMail = result;
    } else {
      messageMail = null;
    }
    setState(() {});
  }

  void validName(String? value) {
    final result = AppValid.validateName(value);
    if (result != null) {
      messageFullName = result;
    } else {
      messageFullName = null;
    }
    setState(() {});
  }

  void validPass(String? value, String? confirmPass) {
    final result = AppValid.validPassword(value);
    if (result != null) {
      messagePass = result;
    } else {
      messagePass = null;
    }
    if (confirmPass!.isNotEmpty) {
      final result = AppValid.validatePasswordConfirm(value!, confirmPass);
      if (result != null) {
        messageCnfPass = result;
      } else {
        messageCnfPass = null;
      }
    }
    setState(() {});
    ();
  }

  void validConfirmPass(String? confirmPass, String? pass) {
    final result = AppValid.validatePasswordConfirm(pass!, confirmPass);
    if (result != null) {
      messageCnfPass = result;
    } else {
      messageCnfPass = null;
    }
    setState(() {});
    ();
  }

  void onEnableRegister() {
    if (messagePass == null &&
        messageMail == null &&
        messageCnfPass == null &&
        messageFullName == null &&
        fullNameController.text.isNotEmpty &&
        cnfPassController.text.isNotEmpty &&
        mailController.text.isNotEmpty &&
        passController.text.isNotEmpty) {
      isEnableButton = true;
    } else {
      isEnableButton = false;
    }
    setState(() {});
    ();
  }

  @override
  void dispose() {
    mailController.dispose();
    passController.dispose();
    fullNameController.dispose();
    cnfPassController.dispose();
    super.dispose();
  }
}
