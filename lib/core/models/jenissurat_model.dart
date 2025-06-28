class JenisSurat {
  final int id;
  final String nama_jenis;

  JenisSurat({required this.id, required this.nama_jenis});

  factory JenisSurat.fromJson(Map<String, dynamic> json) {
    return JenisSurat(
      id: json['id'],
      nama_jenis: json['nama_jenis'],
    );
  }
}
