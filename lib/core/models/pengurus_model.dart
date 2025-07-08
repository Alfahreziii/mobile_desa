class Pengurus {
  final int id;
  final String nama;
  final String email;
  final String foto;
  final String jabatan;
  final String alamat;
  final String noHp;
  final String? jabatanRel;

  Pengurus({
    required this.id,
    required this.nama,
    required this.email,
    required this.foto,
    required this.jabatan,
    required this.alamat,
    required this.noHp,
    required this.jabatanRel,
  });

  factory Pengurus.fromJson(Map<String, dynamic> json) {
    return Pengurus(
      id: json['id'],
      nama: json['nama'],
      email: json['email'],
      foto: json['foto'],
      jabatan: json['jabatan'],
      alamat: json['alamat'],
      noHp: json['no_hp'],
      jabatanRel: json['jabatan_rel'] != null
          ? json['jabatan_rel']['nama_jabatan']
          : null,
    );
  }
}
