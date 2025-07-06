class CpiuranModel {
  final int id;
  final String nama;
  final String no_hp;

  CpiuranModel({
    required this.id,
    required this.nama,
    required this.no_hp,
  });

  factory CpiuranModel.fromJson(Map<String, dynamic> json) {
    return CpiuranModel(
      id: json['id'],
      nama: json['nama'],
      no_hp: json['no_hp'],
    );
  }
}
