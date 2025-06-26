class Rapat {
  final int id;
  final String hari;
  final String judul;
  final String jam_mulai;
  final String jam_selesai;
  final String tempat;
  final String peserta;
  final String bahasan;
  final String created_at_formatted;

  Rapat({
    required this.id,
    required this.hari,
    required this.judul,
    required this.jam_mulai,
    required this.jam_selesai,
    required this.tempat,
    required this.peserta,
    required this.bahasan,
    required this.created_at_formatted,
  });

  factory Rapat.fromJson(Map<String, dynamic> json) {
    return Rapat(
      id: json['id'],
      hari: json['hari'],
      judul: json['judul'],
      jam_mulai: json['jam_mulai'],
      jam_selesai: json['jam_selesai'],
      tempat: json['tempat'],
      peserta: json['peserta'],
      bahasan: json['bahasan'],
      created_at_formatted: json['created_at_formatted'],
    );
  }
}
