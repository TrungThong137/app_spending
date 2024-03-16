// ignore_for_file: deprecated_member_use

import 'package:app_spending/src/configs/widget/button/button.dart';
import 'package:app_spending/src/configs/widget/diaglog/dialog.dart';
import 'package:app_spending/src/configs/widget/loading/loading_diaglog.dart';
import 'package:app_spending/src/page/bottom_navigator/bottom_navigator_screen.dart';
import 'package:app_spending/src/page/login/components/clipper.dart';
import 'package:app_spending/src/page/register/register.dart';
import 'package:app_spending/src/resource/firebase/authentication_server.dart';
import 'package:app_spending/src/utils/app_valid.dart';
import 'package:flutter/material.dart';

import '../../configs/constants/constants.dart';
import '../../configs/widget/form_field/app_form_field.dart';
import '../../configs/widget/text/paragraph.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController mailController;
  late TextEditingController passController;

  bool isEnableButton = false;
  bool isScroll = false;

  String? messagePass;
  String? messageMail;

  late List<FocusNode> listFocus;

  @override
  void initState() {
    super.initState();
    listFocus = List.generate(5, (index) => FocusNode());
    setScroll();
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
                  buildImageLogin(),
                  buildFormLogin(),
                  buildTailLogin(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildContentImageLogin() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          Paragraph(
            content: 'Spending',
            style: STYLE_VERY_BIG.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 40,
              color: AppColors.COLOR_WHITE,
            ),
          ),
          Paragraph(
            textAlign: TextAlign.center,
            content: ' Revenue and expenditure management',
            style: STYLE_VERY_BIG.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 25,
              color: AppColors.COLOR_WHITE,
            ),
          )
        ],
      ),
    );
  }

  Widget buildImageLogin() {
    return Container(
      color: AppColors.COLOR_WHITE,
      height: 300,
      child: ClipPath(
        clipper: HeaderClipper(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(color: AppColors.PRIMARY_ORANGE),
            ),
            buildContentImageLogin(),
          ],
        ),
      ),
    );
  }

  Widget buildFormLogin() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
              buildFieldMail(),
              buildFieldPass(),
              buildLoginButton(),
              const SizedBox(height: 20),
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
        onSignIn();
      },
      validator: messageMail ?? '',
    );
  }

  Widget buildFieldPass() {
    return AppFormField(
      focusNode: listFocus[1],
      labelText: 'Password',
      hintText: 'Enter password',
      textEditingController: passController,
      obscureText: true,
      onChanged: (value) {
        validPass(value);
        onSignIn();
      },
      validator: messagePass ?? '',
    );
  }

  Widget buildLoginButton() {
    return AppButton(
      content: 'Sign In',
      enableButton: isEnableButton,
      onTap: () => onLoginButton(),
    );
  }

  Widget buildSignUpWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: SizeToPadding.sizeVeryBig),
          child: Paragraph(
            content: 'New around here?',
            style: STYLE_MEDIUM.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterScreen(),
                ));
          },
          child: Paragraph(
            content: 'Create An Account',
            style: STYLE_MEDIUM.copyWith(
                color: AppColors.PRIMARY_ORANGE, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget buildTailLogin() {
    return Expanded(
      child: Container(
        width: double.maxFinite,
        color: AppColors.COLOR_WHITE,
        child: buildSignUpWidget(),
      ),
    );
  }

  Future<void> goToHome(BuildContext context) async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomNavigationBarScreen(),
        ));
  }

  void onLoginButton() {
    LoadingDialog.showLoadingDialog(context);
    Authentication().signIn(
        mailController.text.trim(), passController.text.trim(), () async {
      LoadingDialog.hideLoadingDialog(context);
      await goToHome(context);
    }, (msg) {
      LoadingDialog.hideLoadingDialog(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Sending Message"),
      ));
    });
    setState(() {});
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

  void validPass(String? value) {
    final result = AppValid.validPassword(value);
    if (result != null) {
      messagePass = result;
    } else {
      messagePass = null;
    }
    setState(() {});
    ();
  }

  void onSignIn() {
    if (messagePass == null &&
        messageMail == null &&
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
    super.dispose();
  }
}
