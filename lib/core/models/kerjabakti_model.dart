class KerjaBakti {
  final int id;
  final String hari;
  final String judul;
  final String jam_mulai;
  final String jam_selesai;
  final String tempat;
  final String peserta;
  final String created_at_formatted;

  KerjaBakti({
    required this.id,
    required this.hari,
    required this.judul,
    required this.jam_mulai,
    required this.jam_selesai,
    required this.tempat,
    required this.peserta,
    required this.created_at_formatted,
  });

  factory KerjaBakti.fromJson(Map<String, dynamic> json) {
    return KerjaBakti(
      id: json['id'],
      hari: json['hari'],
      judul: json['judul'],
      jam_mulai: json['jam_mulai'],
      jam_selesai: json['jam_selesai'],
      tempat: json['tempat'],
      peserta: json['peserta'],
      created_at_formatted: json['created_at_formatted'],
    );
  }
}
