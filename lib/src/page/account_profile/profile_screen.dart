import 'package:app_spending/src/configs/widget/diaglog/dialog.dart';
import 'package:app_spending/src/page/login/login.dart';
import 'package:app_spending/src/resource/firebase/authentication_server.dart';
import 'package:app_spending/src/utils/date_format_utils.dart';
import 'package:app_spending/src/utils/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../configs/constants/constants.dart';
import '../../configs/widget/text/paragraph.dart';
import '../../resource/model/model.dart';

class ProfileAccountScreen extends StatefulWidget {
  const ProfileAccountScreen({super.key});

  @override
  State<ProfileAccountScreen> createState() => _ProfileAccountScreenState();
}

class _ProfileAccountScreenState extends State<ProfileAccountScreen> {
  Users? users;

  @override
  void initState() {
    super.initState();
    inforUser();
  }

  Future<void> inforUser() async {
    final docRef = FirebaseFirestore.instance
        .collection('user_appSpending')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    final userSnap = await docRef.get();
    final pref = await SharedPreferences.getInstance();
    if (userSnap.exists && userSnap.data() != null) {
      final data = userSnap.data();
      await pref.setString('idUser', data!['idUser']);
      await pref.setString('fullName', data['fullName']);
      await pref.setString('emailAddress', data['emailAddress']);
      await pref.setString('dateCreate', data['dateCreate']);
    }
    users = Users(
      emailAddress: pref.getString('emailAddress'),
      fullName: pref.getString('fullName'),
      idUser: pref.getString('idUser'),
      dateCreate: pref.getString('dateCreate'),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeToPadding.sizeMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerProfileAccount(),
            buildCircleAccount(),
            buildBodyProfileAccount(),
          ],
        ),
      ),
    );
  }

  Widget headerProfileAccount() {
    return Container(
      // color: AppColors.COLOR_GREEN,
      padding: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeBig,
      ),
      child: Paragraph(
          content: 'Profile',
          style: STYLE_VERY_BIG.copyWith(
            color: AppColors.BLACK_500,
            fontWeight: FontWeight.w800,
          )),
    );
  }

  Widget buildCircleAccount() {
    return Center(
      child: Container(
        alignment: Alignment.center,
        height: 100,
        width: 100,
        decoration: const BoxDecoration(
            color: AppColors.PRIMARY_ORANGE,
            borderRadius: BorderRadius.all(Radius.circular(100))),
        child: const CircleAvatar(
          backgroundColor: AppColors.COLOR_WHITE,
          radius: 40,
          child: Icon(
            Icons.person,
            size: 75,
            color: AppColors.PRIMARY_ORANGE,
          ),
        ),
      ),
    );
  }

  Widget informationUser({String? title, String? content, Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
      child: Row(
        children: [
          Paragraph(
            content: '$title',
            style: STYLE_MEDIUM.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(
            width: SizeToPadding.sizeMedium,
          ),
          Paragraph(
            content: content ?? '',
            style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }

  Widget buildBodyProfileAccount() {
    return Padding(
      padding: EdgeInsets.all(SizeToPadding.sizeVeryBig),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          informationUser(title: 'Name:', content: users?.fullName),
          informationUser(title: 'Email:', content: users?.emailAddress),
          informationUser(
              title: 'Member Since:',
              content: AppDateUtils.formatDaTime(users?.dateCreate)),
          GestureDetector(
              onTap: () async {
                await onLogout();
              },
              child: informationUser(
                  title: 'Log Out', color: AppColors.Red_Money)),
        ],
      ),
    );
  }

  void goToLogin() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ));
  }

  Future<void> onDeleteAccount() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WarningDialog(
              title: 'Delete account',
              content: 'Do you want to delete your account?',
              leftButtonName: 'Cancel',
              rightButtonName: 'Confirm',
              onTapLeft: () => Navigator.pop(context),
              onTapRight: () {
                Navigator.of(context).pop();
                deletedLocal();
                goToLogin();
              },
            ));
  }

  Future<void> onLogout() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WarningDialog(
              title: 'Logout',
              content: 'Do you want to logout?',
              leftButtonName: 'Cancel',
              rightButtonName: 'Confirm',
              onTapLeft: () => Navigator.pop(context),
              onTapRight: () {
                Navigator.of(context).pop();
                logout();
                deleteToken();
                goToLogin();
              },
            ));
  }

  Future<void> deletedLocal() async {
    await Authentication().deleteAccountUSer();
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
    setState(() {});
  }

  Future<void> deleteToken() async {
    AppPref.deleteToken();
    setState(() {});
  }

  Future<void> logout() async {
    await Authentication().signOut();
  }
}
