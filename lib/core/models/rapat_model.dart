class Rapat {
  final int id;
  final String hari;
  final String judul;
  final String jamMulai;
  final String jamSelesai;
  final String tempat;
  final String peserta;
  final String bahasan;
  final String createdAtFormatted;

  Rapat({
    required this.id,
    required this.hari,
    required this.judul,
    required this.jamMulai,
    required this.jamSelesai,
    required this.tempat,
    required this.peserta,
    required this.bahasan,
    required this.createdAtFormatted,
  });

  factory Rapat.fromJson(Map<String, dynamic> json) {
    return Rapat(
      id: json['id'],
      hari: json['hari'],
      judul: json['judul'],
      jamMulai: json['jam_mulai'],
      jamSelesai: json['jam_selesai'],
      tempat: json['tempat'],
      peserta: json['peserta'],
      bahasan: json['bahasan'],
      createdAtFormatted: json['created_at_formatted'],
    );
  }
}
