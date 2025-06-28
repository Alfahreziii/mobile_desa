class Surat {
  final int id;
  final String atas_nama;
  final int id_jenissurat;
  final String ditunjukan;
  final String keterangan;

  Surat({
    required this.id,
    required this.atas_nama,
    required this.id_jenissurat,
    required this.ditunjukan,
    required this.keterangan,
  });

  factory Surat.fromJson(Map<String, dynamic> json) {
    return Surat(
      id: json['id'],
      atas_nama: json['atas_nama'],
      id_jenissurat: json['id_jenissurat'],
      ditunjukan: json['ditunjukan'],
      keterangan: json['keterangan'],
    );
  }
}
