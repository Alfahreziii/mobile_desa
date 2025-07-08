class Laporan {
  final int id;
  final String tanggalLaporan;
  final int jumlahRumah;
  final int jumlahPenduduk;
  final int jumlahKk;
  final int jumlahLaki;
  final int jumlahPerempuan;
  final int jumlahMeninggal;
  final int jumlahLahir;
  final int jumlahPindah;

  Laporan({
    required this.id,
    required this.tanggalLaporan,
    required this.jumlahRumah,
    required this.jumlahPenduduk,
    required this.jumlahKk,
    required this.jumlahLaki,
    required this.jumlahPerempuan,
    required this.jumlahMeninggal,
    required this.jumlahLahir,
    required this.jumlahPindah,
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
      tanggalLaporan: json['tanggal_laporan'].toString(),
      jumlahRumah: int.parse(json['jumlah_rumah'].toString()),
      jumlahPenduduk: int.parse(json['jumlah_penduduk'].toString()),
      jumlahKk: int.parse(json['jumlah_kk'].toString()),
      jumlahLaki: int.parse(json['jumlah_laki'].toString()),
      jumlahPerempuan: int.parse(json['jumlah_perempuan'].toString()),
      jumlahMeninggal: int.parse(json['jumlah_perempuan'].toString()),
      jumlahLahir: int.parse(json['jumlah_lahir'].toString()),
      jumlahPindah: int.parse(json['jumlah_pindah'].toString()),
    );
  }
}
