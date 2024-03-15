import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../configs/constants/constants.dart';
import '../../../configs/widget/text/paragraph.dart';
import '../../../resource/model/model.dart';
import '../bottom_sheet/bottom_sheet_month.dart';

class BuildCalendar extends StatefulWidget {
  const BuildCalendar({
    super.key,
    required this.dateTime,
    this.onSelectDate,
  });

  final DateTime dateTime;
  final Function(DateTime date)? onSelectDate;

  @override
  State<BuildCalendar> createState() => _BuildCalendarState();
}

class _BuildCalendarState extends State<BuildCalendar> {

  late DateTime dateTime;
  late int month;
  late int year;

  bool isWeekend=false;

  late String currentDay;

  Timer? timer;

  List<DateCalendarModel> listDay=[];
  

  @override
  void initState() {
    super.initState();
    dateTime= widget.dateTime;
    month= dateTime.month;
    year= dateTime.year;
    currentDay= '$year-$month-${dateTime.day}';
    getListDay();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: SizeToPadding.sizeMedium,
        bottom: SizeToPadding.sizeVeryBig),
      child: Column(
        children: [
          buildHeaderCalendar(context),
          buildBodyCalendar(),
          buildSelectTime(),
        ],
      ),
    );
  }

  Widget buildMonthAndYearCalendar(BuildContext context){
    return InkWell(
      onTap: () => BottomSheetMonth(
        context: context,
        mode: CupertinoDatePickerMode.monthYear,
        title: 'Chọn tháng',
        onTapButton: () => Navigator.pop(context),
        onUpdateDateTime: (value) => setState(() {
          dateTime= value;
          month= dateTime.month;
          year= dateTime.year;
          getListDay();
        }),
        dateTime: dateTime,
      ).showSelectTime(),
      child: Row(
        children: [
          Paragraph(
            content: 'Month ${dateTime.month}/${dateTime.year}',
            style: STYLE_MEDIUM.copyWith(
              fontWeight: FontWeight.w600
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, 
            color: AppColors.PRIMARY_ORANGE,
            size: 17,
          )
        ],
      ),
    );
  }

  Widget buildHeaderCalendar(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildMonthAndYearCalendar(context),
        Container(
          width: 80,
          padding: EdgeInsets.only(right: SizeToPadding.sizeMedium),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => subMonth(),
                child: const Icon(Icons.arrow_back_ios_new, 
                  color: AppColors.PRIMARY_ORANGE,
                  size: 23,
                ),
              ),
              InkWell(
                onTap: ()=> addMonth(),
                child: const Icon(Icons.arrow_forward_ios_rounded, 
                  color: AppColors.PRIMARY_ORANGE,
                  size: 23,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildWeekDays({String? content, Color? color,
    bool isDayCurrent=false, bool isTitle=false}){
    int days= isTitle==false? int.parse(content??'0'): 0;
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Center(
        child: InkWell(
          onTap: () {
            if(!isTitle){
              currentDay='$year-$month-$content';
              dateTime= DateFormat('yyyy-MM-dd').parse(currentDay);
              setState(() {});
              widget.onSelectDate!(dateTime);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 7, horizontal: isTitle==false
                ? (days<10)? 11: 7 : 0
            ),
            decoration: BoxDecoration(
              border: isDayCurrent? Border.all(color: AppColors.PRIMARY_ORANGE,): null,
              color: currentDay=='$year-$month-$content'
                ? AppColors.PRIMARY_ORANGE: null,
              borderRadius: BorderRadius.circular(BorderRadiusSize.sizeBig),
            ),
            child: Paragraph(
              content: content??'',
              style: STYLE_SMALL.copyWith(
                color:  currentDay==('$year-$month-$content')? AppColors.COLOR_WHITE: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBodyCalendar(){
    var day=0;
    return Padding(
      padding: EdgeInsets.only(right: SizeToPadding.sizeMedium,),
      child: Table(
        children: [
          TableRow(
            decoration: const BoxDecoration(color: AppColors.COLOR_WHITE),
            children: [
              buildWeekDays(content: 'MON', isTitle: true),
              buildWeekDays(content: 'TUE', isTitle: true),
              buildWeekDays(content: 'WED', isTitle: true),
              buildWeekDays(content: 'THU', isTitle: true),
              buildWeekDays(content: 'FRI', isTitle: true),
              buildWeekDays(content: 'SAT', isTitle: true),
              buildWeekDays(content: 'SUN', isTitle: true),
            ]
          ),
          ...List.generate(isWeekend? 6: 5, (index) => 
            TableRow(
              children: List.generate(7, (d) {
                day++;
                return buildWeekDays(
                  content: listDay[day-1].date,
                  isDayCurrent: listDay[day-1].isCurrentDay,
                );
              })
            )
          ),
        ],
      ),
    );
  }

  Widget buildButtonSelectTime(){
    return InkWell(
      onTap: () => BottomSheetMonth(
        context: context, 
        dateTime: dateTime,
        mode: CupertinoDatePickerMode.time,
        title: 'Chọn giờ',
        onUpdateDateTime: (value) => setState(() {
          dateTime= value;
          month= dateTime.month;
          year= dateTime.year;
          widget.onSelectDate!(dateTime);
        }),
        onTapButton: () => Navigator.pop(context),
      ).showSelectTime(),
      child: Container(
        width: 70,
        margin: EdgeInsets.only(right: SizeToPadding.sizeMedium),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeVerySmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(BorderRadiusSize.sizeMedium),
          color: AppColors.BLACK_200,
        ),
        child: Paragraph(
          content: DateFormat('HH:mm').format(dateTime),
          style: STYLE_MEDIUM.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget buildSelectTime(){
    return Padding(
      padding: EdgeInsets.only(top: SizeToPadding.sizeMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Paragraph(
            content: 'Time',
            style: STYLE_MEDIUM.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          buildButtonSelectTime(),
        ],
      ),
    );
  }

  void subMonth() {
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }else{
      timer = Timer(const Duration(milliseconds: 300), () {
        if(month>1){
          month--;
        }else{
          month=12;
          year--;
        }
        dateTime= DateTime(year, month, 1);
        getListDay();
        setState(() {});
      });
    }
  }

  void addMonth(){
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }else{
      timer = Timer(const Duration(milliseconds: 500), () {
        if(month<12){
          month++;
        }else{
          month=1;
          year++;
        }
        dateTime= DateTime(year, month, 1);
        getListDay();
        setState(() {});
      });
    }
  }

  void setWeekend(int weekday){
    if(weekday==6 || weekday==7){
      isWeekend=true;
    }else{
      isWeekend=false;
    }
    setState(() {});
  }

  bool checkCurrentDay(num day){
    final date= DateTime.now();
    if(date.month<10){
      if(day<10){
        return date.toString().contains('$year-0$month-0$day');
      }else{
        return date.toString().contains('$year-0$month-$day');
      }
    }else{
      if(day<10){
        return date.toString().contains('$year-0$month-0$day');
      }else{
        return date.toString().contains('$year-$month-$day');
      }
    }
  }

  void getDataDay(){
    final lastDay= DateTime(year, month+1, 0).day;
    final date= DateTime(year, month, 1);
    // setWeekend(date.weekday);
    for(var i=1; i<=lastDay; i++){
      listDay.add(
        DateCalendarModel(
          date: i.toString(),
          isCurrentDay: checkCurrentDay(i),
        ),
      );
    }
    for(var i=1; i<=(isWeekend?42:35 -lastDay-(date.weekday-2)); i++){
      listDay.add(DateCalendarModel());
    }
    setState(() {});
  }

  void getListDay(){
    listDay.clear();
    final date= DateTime(year, month, 1);
    setWeekend(date.weekday);
    if(date.weekday==2){
      getDataDay();
    }else{
      for(var i=date.weekday-2; i>=0; i--){
        listDay.add(DateCalendarModel());
      }
      getDataDay();
    }
    setState(() {});
  }
}