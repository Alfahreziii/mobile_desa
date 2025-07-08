class Geografis {
  final int id;
  final String judul;
  final String foto;
  final String createdAtFormatted;

  Geografis({
    required this.id,
    required this.judul,
    required this.foto,
    required this.createdAtFormatted,
  });

  factory Geografis.fromJson(Map<String, dynamic> json) {
    return Geografis(
      id: json['id'],
      judul: json['judul'],
      foto: json['foto'],
      createdAtFormatted: json['created_at_formatted'],
    );
  }
}
