class Product {
  final int id;
  final int id_toko;
  final String nama_produk;
  final String deskripsi;
  final String foto;
  final int harga;
  final int stok;
  final String no_hp_toko;

  Product({
    required this.id,
    required this.id_toko,
    required this.nama_produk,
    required this.deskripsi,
    required this.foto,
    required this.harga,
    required this.stok,
    required this.no_hp_toko,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      id_toko: json['id_toko'],
      nama_produk: json['nama_produk'],
      deskripsi: json['deskripsi'],
      foto: json['foto'],
      harga: int.parse(json['harga'].toString()),
      stok: int.parse(json['stok'].toString()),
      no_hp_toko: json['no_hp_toko'],
    );
  }
}
