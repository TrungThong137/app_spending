import 'dart:async';

import 'package:app_spending/src/configs/constants/constants.dart';
import 'package:app_spending/src/configs/widget/text/paragraph.dart';
import 'package:app_spending/src/resource/firebase/firebase_spending.dart';
import 'package:app_spending/src/resource/model/todo_model.dart';
import 'package:app_spending/src/utils/app_fomat_money.dart';
import 'package:app_spending/src/utils/date_format_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<SpendingModel> listSpending = [];

  Timer? timer;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      readDataTodoFirebase();
      Timer.periodic(const Duration(seconds: 2), (Timer t) => setState(() {}));
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> readDataTodoFirebase() async {
    final idUser = FirebaseAuth.instance.currentUser?.uid;
    final data = await FirebaseFirestore.instance
        .collection('spending_AppSpending')
        .where('idUser', isEqualTo: idUser)
        .get();
    if (data.docs.isEmpty) {
      return;
    } else {
      FirebaseFirestore.instance
          .collection('spending_AppSpending')
          .where('idUser', isEqualTo: idUser)
          .orderBy('dateTime', descending: false)
          .snapshots()
          .map((snapshots) => snapshots.docs.map((doc) {
                final data = doc.data();
                return SpendingModel.fromJson(data);
              }).toList())
          .listen((data) {
        listSpending = data;
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Paragraph(
            content: 'History',
            style: STYLE_BIG.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: SizeToPadding.sizeMedium),
            height: MediaQuery.sizeOf(context).height - 150,
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  color: AppColors.BLACK_200,
                ),
                Visibility(
                  visible: listSpending.isNotEmpty ? true : false,
                  child: Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: listSpending.length,
                      itemBuilder: (context, index) => buildItemToDo(index),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void doNothing(BuildContext context, String id) async {
    await FireStoreSpending.removeTodoFirebase(id);
    setState(() {});
  }

  Widget buildItemToDo(int index) {
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            flex: 2,
            onPressed: (_) {
              doNothing(context, listSpending[index].idSpending!);
            },
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          )
        ],
      ),
      child: Card(
        child: Container(
          padding: EdgeInsets.all(SizeToPadding.sizeMedium),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(BorderRadiusSize.sizeMedium)),
          ),
          child: Column(
            children: [
              buildMoney(index),
              Padding(
                padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
                child: buildInfoCard(
                  title: 'Note:',
                  content: listSpending[index].note,
                ),
              ),
              buildInfoCard(
                iconData: Icons.calendar_month,
                content: AppDateUtils.formatDaTime(listSpending[index].dateTime)
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMoney(int index){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Paragraph(
          content: 'Money',
          style: STYLE_MEDIUM.copyWith(
            fontWeight: FontWeight.w600
          ),
        ),
        Container(
          width: MediaQuery.sizeOf(context).width-200,
          alignment: Alignment.centerRight,
          child: Paragraph(
            content: (listSpending[index].moneySpending??0)!=0
            ? '- ${AppCurrencyFormat.formatMoneyD(listSpending[index].moneySpending??0)}'
            : '+ ${AppCurrencyFormat.formatMoneyD(listSpending[index].moneyIncome??0)}',
            style: STYLE_MEDIUM.copyWith(
              color: (listSpending[index].moneySpending??0)!=0
              ? AppColors.PRIMARY_RED
              : AppColors.Green_Money,
              fontWeight: FontWeight.w600
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget buildInfoCard({String? title, String? content, IconData? iconData}){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        iconData!=null? 
        Icon(iconData)
        :Paragraph(
          content: title,
          style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w600),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeToPadding.sizeSmall),
          width: MediaQuery.sizeOf(context).width-150,
          child: Paragraph(
            content: content,
            style: STYLE_MEDIUM.copyWith(),
          ),
        ),
      ],
    );
  }

  // @override
  // void dispose() {
  //   timer?.cancel();
  //   super.dispose();
  // }
}
