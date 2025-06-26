class Berita {
  final int id;
  final String judul;
  final String deskripsi;
  final String foto;
  final String created_at_formatted;

  Berita({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.foto,
    required this.created_at_formatted,
  });

  factory Berita.fromJson(Map<String, dynamic> json) {
    return Berita(
      id: json['id'],
      judul: json['judul'],
      deskripsi: json['deskripsi'],
      foto: json['foto'],
      created_at_formatted: json['created_at_formatted'],
    );
  }
}
