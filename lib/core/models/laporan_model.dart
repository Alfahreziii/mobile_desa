class Laporan {
  final int id;
  final String tanggal_laporan;
  final int jumlah_rumah;
  final int jumlah_penduduk;
  final int jumlah_kk;
  final int jumlah_laki;
  final int jumlah_perempuan;
  final int jumlah_meninggal;
  final int jumlah_lahir;
  final int jumlah_pindah;

  Laporan({
    required this.id,
    required this.tanggal_laporan,
    required this.jumlah_rumah,
    required this.jumlah_penduduk,
    required this.jumlah_kk,
    required this.jumlah_laki,
    required this.jumlah_perempuan,
    required this.jumlah_meninggal,
    required this.jumlah_lahir,
    required this.jumlah_pindah,
  });
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Laporan && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory Laporan.fromJson(Map<String, dynamic> json) {
    return Laporan(
      id: int.parse(json['id'].toString()),
      tanggal_laporan: json['tanggal_laporan'].toString(),
      jumlah_rumah: int.parse(json['jumlah_rumah'].toString()),
      jumlah_penduduk: int.parse(json['jumlah_penduduk'].toString()),
      jumlah_kk: int.parse(json['jumlah_kk'].toString()),
      jumlah_laki: int.parse(json['jumlah_laki'].toString()),
      jumlah_perempuan: int.parse(json['jumlah_perempuan'].toString()),
      jumlah_meninggal: int.parse(json['jumlah_meninggal'].toString()),
      jumlah_lahir: int.parse(json['jumlah_lahir'].toString()),
      jumlah_pindah: int.parse(json['jumlah_pindah'].toString()),
    );
  }
}
