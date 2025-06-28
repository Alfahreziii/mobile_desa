class IuranModel {
  final int id;
  final String bulan;
  final int harga;
  final String status;

  IuranModel({
    required this.id,
    required this.bulan,
    required this.harga,
    required this.status,
  });

  factory IuranModel.fromJson(Map<String, dynamic> json) {
    return IuranModel(
      id: json['id'],
      bulan: json['bulan'],
      harga: json['harga'],
      status: json['status'],
    );
  }
}
