class Tahlil {
  final int id;
  final String hari;
  final String judul;
  final String jam_mulai;
  final String jam_selesai;
  final String tempat;
  final String ustadzah;
  final String created_at_formatted;

  Tahlil({
    required this.id,
    required this.hari,
    required this.judul,
    required this.jam_mulai,
    required this.jam_selesai,
    required this.tempat,
    required this.ustadzah,
    required this.created_at_formatted,
  });

  factory Tahlil.fromJson(Map<String, dynamic> json) {
    return Tahlil(
      id: json['id'],
      hari: json['hari'],
      judul: json['judul'],
      jam_mulai: json['jam_mulai'],
      jam_selesai: json['jam_selesai'],
      tempat: json['tempat'],
      ustadzah: json['ustadzah'],
      created_at_formatted: json['created_at_formatted'],
    );
  }
}
