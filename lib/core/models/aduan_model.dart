class Aduan {
  final int id;
  final String judul;
  final String keterangan;
  final String foto;

  Aduan({
    required this.id,
    required this.judul,
    required this.keterangan,
    required this.foto,
  });

  factory Aduan.fromJson(Map<String, dynamic> json) {
    return Aduan(
      id: json['id'],
      judul: json['judul'],
      keterangan: json['keterangan'],
      foto: json['foto'],
    );
  }
}
