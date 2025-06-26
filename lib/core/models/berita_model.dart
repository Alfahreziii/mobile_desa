class Berita {
  final int id;
  final String judul;
  final String deskripsi;
  final String foto;
  final String created_at;

  Berita({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.foto,
    required this.created_at,
  });

  factory Berita.fromJson(Map<String, dynamic> json) {
    return Berita(
      id: json['id'],
      judul: json['judul'],
      deskripsi: json['deskripsi'],
      foto: json['foto'],
      created_at: json['created_at'],
    );
  }
}
