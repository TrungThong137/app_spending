class BodyIndex {
  BodyIndex({
    this.idUser,
    this.height,
    this.weight,
  });

  final String? idUser;
  final double? height;
  final double? weight;

  static BodyIndex fromJson(Map<String, dynamic> json) => BodyIndex(
        idUser: json['idUser'],
        height: json['height'],
        weight: json['weight'],
      );

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'height': height,
        'weight': weight,
      };
}
