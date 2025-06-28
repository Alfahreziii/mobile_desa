class Geografis {
  final int id;
  final String judul;
  final String foto;
  final String created_at_formatted;

  Geografis({
    required this.id,
    required this.judul,
    required this.foto,
    required this.created_at_formatted,
  });

  factory Geografis.fromJson(Map<String, dynamic> json) {
    return Geografis(
      id: json['id'],
      judul: json['judul'],
      foto: json['foto'],
      created_at_formatted: json['created_at_formatted'],
    );
  }
}
