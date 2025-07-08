class Product {
  final int id;
  final int idToko;
  final String namaProduk;
  final String deskripsi;
  final String foto;
  final int harga;
  final int stok;
  final String noHpToko;

  Product({
    required this.id,
    required this.idToko,
    required this.namaProduk,
    required this.deskripsi,
    required this.foto,
    required this.harga,
    required this.stok,
    required this.noHpToko,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      idToko: json['id_toko'],
      namaProduk: json['nama_produk'],
      deskripsi: json['deskripsi'],
      foto: json['foto'],
      harga: int.parse(json['harga'].toString()),
      stok: int.parse(json['stok'].toString()),
      noHpToko: json['no_hp_toko'] ?? '', // Handle null case
    );
  }
}
