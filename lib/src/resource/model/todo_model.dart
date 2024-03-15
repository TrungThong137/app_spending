class SpendingModel {
  SpendingModel({
    this.idUser,
    this.note,
    this.dateTime,
    this.idSpending,
    this.moneyIncome,
    this.moneySpending,
  });

  final String? idUser;
  final String? note;
  final String? dateTime;
  final String? idSpending;
  final double? moneySpending;
  final double? moneyIncome;

  static SpendingModel fromJson(Map<String, dynamic> json) => SpendingModel(
      idUser: json['idUser'],
      note: json['note'],
      dateTime: json['dateTime'],
      idSpending: json['idSpending'],
      moneyIncome: json['moneyIncome'],
      moneySpending: json['moneySpending'],
    );

  Map<String, dynamic> toJson() => {
      // 'isCheckBox': isCheckBox,
    };
}
