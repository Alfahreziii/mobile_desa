class Toko {
  final int id;
  final String? namaToko;
  final String? deskripsi;
  final String? foto;
  final String? alamat;
  final String? noHp;

  Toko({
    required this.id,
    required this.namaToko,
    required this.deskripsi,
    required this.foto,
    required this.alamat,
    required this.noHp,
  });

  factory Toko.fromJson(Map<String, dynamic> json) {
    return Toko(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      namaToko: json['nama_toko'],
      deskripsi: json['deskripsi'],
      foto: json['foto'],
      alamat: json['alamat'],
      noHp: json['no_hp'],
    );
  }
}
