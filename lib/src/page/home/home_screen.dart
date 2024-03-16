import 'dart:async';

import 'package:app_spending/src/configs/constants/constants.dart';
import 'package:app_spending/src/configs/widget/form_field/app_form_field.dart';
import 'package:app_spending/src/configs/widget/text/paragraph.dart';
import 'package:app_spending/src/utils/app_valid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../configs/widget/button/button.dart';
import '../../configs/widget/calendar/build_calendar.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/firebase/firebase_spending.dart';
import '../../resource/model/todo_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectButton = 0;

  late TextEditingController noteController;
  late TextEditingController moneyController;
  late DateTime dateTime;

  String? messageMoney;

  bool isEnableButton = false;

  List<String> listButtonSelect = [
    'Spending',
    'Income',
  ];

  Timer? timer;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      noteController = TextEditingController();
      moneyController = TextEditingController();
      dateTime = DateTime.now();
      timer = Timer.periodic(
          const Duration(seconds: 2), (Timer t) => setState(() {}));
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          centerTitle: true,
          title: Paragraph(
            content: 'Home',
            style: STYLE_LARGE_BIG.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeToPadding.sizeMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  color: AppColors.BLACK_200,
                ),
                buildButtonSpending(),
                buildFormInput(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButtonSpending() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Center(
        child: CupertinoSlidingSegmentedControl(
          groupValue: selectButton,
          thumbColor: AppColors.PRIMARY_ORANGE,
          children: <int, Widget>{
            for (int i = 0; i < listButtonSelect.length; i++)
              i: Container(
                alignment: Alignment.center,
                width: 80,
                height: 40,
                child: Paragraph(
                  content: listButtonSelect[i],
                  style: STYLE_MEDIUM.copyWith(
                    fontWeight: FontWeight.w600,
                    color: selectButton == i
                        ? AppColors.COLOR_WHITE
                        : AppColors.BLACK_500,
                  ),
                ),
              )
          },
          onValueChanged: (i) {
            onChangeButtonSelect(i ?? 0);
          },
        ),
      ),
    );
  }

  Widget buildFormInput() {
    return Container(
      margin: EdgeInsets.only(
        top: SizeToPadding.sizeMedium,
      ),
      padding: EdgeInsets.only(
        left: SizeToPadding.sizeMedium,
        bottom: SizeToPadding.sizeVeryBig,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildFieldMoney(),
          buildFieldNoteCard(),
          buildCalendar(),
          buildButtonCard(),
        ],
      ),
    );
  }

  Widget buildFieldMoney() {
    return AppFormField(
      validator: messageMoney,
      textEditingController: moneyController,
      keyboardType: TextInputType.number,
      labelText: selectButton == 0 ? 'Spending Money' : 'Income Money',
      hintText: 'Enter money',
      onChanged: (value) async {
        await validMoney(value);
        await onEnableButton();
      },
    );
  }

  Widget buildFieldNoteCard() {
    return AppFormField(
      textEditingController: noteController,
      labelText: 'Note',
      hintText: 'Enter Note',
      maxLines: 3,
      onChanged: (value) => onEnableButton(),
    );
  }

  Widget buildCalendar() {
    return BuildCalendar(
      dateTime: dateTime,
      onSelectDate: (date) => setState(() {
        dateTime = date;
      }),
    );
  }

  Widget buildButtonCard() {
    return Padding(
      padding: EdgeInsets.only(right: SizeToPadding.sizeMedium),
      child: AppButton(
        enableButton: isEnableButton,
        content: 'Save',
        onTap: () => onSave(),
      ),
    );
  }

  void onSave() {
    LoadingDialog.showLoadingDialog(context);
    FireStoreSpending.createSpendingFirebase(SpendingModel(
            dateTime: dateTime.toString(),
            idUser: FirebaseAuth.instance.currentUser?.uid,
            note: noteController.text.trim(),
            moneyIncome: selectButton == 0
                ? 0
                : double.parse(moneyController.text.trim()),
            moneySpending: selectButton == 0
                ? double.parse(moneyController.text.trim())
                : 0))
        .then((value) async {
      LoadingDialog.hideLoadingDialog(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Paragraph(
        content: 'Add Success',
      )));
      await clearData();
    }).catchError((onError) {
      LoadingDialog.hideLoadingDialog(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Paragraph(
        content: '$onError',
      )));
    });
  }

  Future<void> validMoney(String? value) async {
    final result = AppValid.validMoney(value);
    if (result != null) {
      messageMoney = result;
    } else {
      messageMoney = null;
    }
    setState(() {});
  }

  Future<void> onEnableButton() async {
    if (moneyController.text == '' || messageMoney != null) {
      isEnableButton = false;
    } else {
      isEnableButton = true;
    }
    setState(() {});
  }

  Future<void> clearData() async {
    noteController.text = '';
    moneyController.text = '';
    await onEnableButton();
    setState(() {});
  }

  void onChangeButtonSelect(int i) {
    selectButton = i;
    setState(() {});
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
