class KerjaBakti {
  final int id;
  final String hari;
  final String judul;
  final String jamMulai;
  final String jamSelesai;
  final String tempat;
  final String peserta;
  final String createdAtFormatted;

  KerjaBakti({
    required this.id,
    required this.hari,
    required this.judul,
    required this.jamMulai,
    required this.jamSelesai,
    required this.tempat,
    required this.peserta,
    required this.createdAtFormatted,
  });

  factory KerjaBakti.fromJson(Map<String, dynamic> json) {
    return KerjaBakti(
      id: json['id'],
      hari: json['hari'],
      judul: json['judul'],
      jamMulai: json['jam_mulai'],
      jamSelesai: json['jam_selesai'],
      tempat: json['tempat'],
      peserta: json['peserta'],
      createdAtFormatted: json['created_at_formatted'],
    );
  }
}
