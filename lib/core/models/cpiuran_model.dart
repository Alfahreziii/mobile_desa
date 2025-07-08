class CpiuranModel {
  final int id;
  final String nama;
  final String noHp;

  CpiuranModel({
    required this.id,
    required this.nama,
    required this.noHp,
  });

  factory CpiuranModel.fromJson(Map<String, dynamic> json) {
    return CpiuranModel(
      id: json['id'],
      nama: json['nama'],
      noHp: json['no_hp'],
    );
  }
}
