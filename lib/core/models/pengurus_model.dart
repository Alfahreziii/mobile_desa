class Pengurus {
  final int id;
  final String nama;
  final String email;
  final String foto;
  final String jabatan;
  final String alamat;
  final String no_hp;
  final String? jabatan_rel;

  Pengurus({
    required this.id,
    required this.nama,
    required this.email,
    required this.foto,
    required this.jabatan,
    required this.alamat,
    required this.no_hp,
    required this.jabatan_rel,
  });

  factory Pengurus.fromJson(Map<String, dynamic> json) {
    return Pengurus(
      id: json['id'],
      nama: json['nama'],
      email: json['email'],
      foto: json['foto'],
      jabatan: json['jabatan'],
      alamat: json['alamat'],
      no_hp: json['no_hp'],
      jabatan_rel: json['jabatan_rel'] != null
          ? json['jabatan_rel']['nama_jabatan']
          : null,
    );
  }
}
