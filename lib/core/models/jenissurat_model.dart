class JenisSurat {
  final int id;
  final String namaJenis;

  JenisSurat({required this.id, required this.namaJenis});

  factory JenisSurat.fromJson(Map<String, dynamic> json) {
    return JenisSurat(
      id: json['id'],
      namaJenis: json['nama_jenis'],
    );
  }
}
