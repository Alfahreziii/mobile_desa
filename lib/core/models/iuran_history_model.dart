class IuranHistoryModel {
  final int id;
  final String orderId;
  final String status;
  final DateTime paidAt;
  final String namaUser;
  final int userId;
  final String emailUser;
  final DateTime bulanIuran;
  final int iuranId;
  final int hargaIuran;

  IuranHistoryModel({
    required this.id,
    required this.orderId,
    required this.status,
    required this.paidAt,
    required this.namaUser,
    required this.userId,
    required this.emailUser,
    required this.bulanIuran,
    required this.iuranId,
    required this.hargaIuran,
  });

  factory IuranHistoryModel.fromJson(Map<String, dynamic> json) {
    return IuranHistoryModel(
      id: json['id'],
      orderId: json['order_id'],
      status: json['status'],
      paidAt: DateTime.parse(json['paid_at']),
      namaUser: json['nama_user'],
      userId: json['user_id'],
      emailUser: json['email_user'],
      bulanIuran: DateTime.parse(json['bulan_iuran']),
      iuranId: json['iuran_id'],
      hargaIuran: json['harga_iuran'],
    );
  }
}
