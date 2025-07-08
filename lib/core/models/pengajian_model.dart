class Pengajian {
  final int id;
  final String hari;
  final String judul;
  final String jamMulai;
  final String jamSelesai;
  final String tempat;
  final String ustadzah;
  final String createdAtFormatted;

  Pengajian({
    required this.id,
    required this.hari,
    required this.judul,
    required this.jamMulai,
    required this.jamSelesai,
    required this.tempat,
    required this.ustadzah,
    required this.createdAtFormatted,
  });

  factory Pengajian.fromJson(Map<String, dynamic> json) {
    return Pengajian(
      id: json['id'],
      hari: json['hari'],
      judul: json['judul'],
      jamMulai: json['jam_mulai'],
      jamSelesai: json['jam_selesai'],
      tempat: json['tempat'],
      ustadzah: json['ustadzah'],
      createdAtFormatted: json['created_at_formatted'],
    );
  }
}
