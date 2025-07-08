class Surat {
  final int id;
  final String atasNama;
  final int idJenissurat;
  final String ditunjukan;
  final String keterangan;

  Surat({
    required this.id,
    required this.atasNama,
    required this.idJenissurat,
    required this.ditunjukan,
    required this.keterangan,
  });

  factory Surat.fromJson(Map<String, dynamic> json) {
    return Surat(
      id: json['id'],
      atasNama: json['atas_nama'],
      idJenissurat: json['id_jenissurat'],
      ditunjukan: json['ditunjukan'],
      keterangan: json['keterangan'],
    );
  }
}
