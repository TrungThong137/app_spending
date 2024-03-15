class Users {
  Users({
    this.idUser,
    this.fullName,
    this.emailAddress,
    this.dateCreate,
  });

  final String? idUser;
  final String? fullName;
  final String? emailAddress;
  final String? dateCreate;

  static Users fromJson(Map<String, dynamic> json) => Users(
        idUser: json['idUser'],
        fullName: json['fullName'],
        emailAddress: json['emailAddress'],
        dateCreate: json['dateCreate'],
      );

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'fullName': fullName,
        'emailAddress': emailAddress,
      };
}
