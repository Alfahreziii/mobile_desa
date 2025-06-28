class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String nomorKK;
  final String nomorNIK;
  final String tempatLahir;
  final String tanggalLahir;
  final String jenisKelamin;
  final String pekerjaan;
  final String status;
  final String alamatRT005;
  final String alamatKTP;
  final String role;

  UserModel({
    this.id = '',
    required this.name,
    required this.email,
    required this.password,
    required this.nomorKK,
    required this.nomorNIK,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.pekerjaan,
    required this.status,
    required this.alamatRT005,
    required this.alamatKTP,
    this.role = 'user',
  });

  /// ✅ Tambahkan ini
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: '', // Jangan isi password dari API
      nomorKK: json['nomor_kk'] ?? '',
      nomorNIK: json['nomor_nik'] ?? '',
      tempatLahir: json['tempat_lahir'] ?? '',
      tanggalLahir: json['tanggal_lahir'] ?? '',
      jenisKelamin: json['jenis_kelamin'] ?? '',
      pekerjaan: json['pekerjaan'] ?? '',
      status: json['status'] ?? '',
      alamatRT005: json['alamat_rt005'] ?? '',
      alamatKTP: json['alamat_ktp'] ?? '',
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJson({bool onlyEmailPassword = false}) {
    if (onlyEmailPassword) {
      return {
        'email': email,
        'password': password,
      };
    }

    return {
      'name': name,
      'email': email,
      'password': password,
      'nomor_kk': nomorKK,
      'nomor_nik': nomorNIK,
      'tempat_lahir': tempatLahir,
      'tanggal_lahir': _formatDateOnly(tanggalLahir),
      'jenis_kelamin': jenisKelamin,
      'pekerjaan': pekerjaan,
      'status': status,
      'alamat_rt005': alamatRT005,
      'alamat_ktp': alamatKTP,
      'role': role,
    };
  }

  String _formatDateOnly(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return isoDate;
    }
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? nomorKK,
    String? nomorNIK,
    String? tempatLahir,
    String? tanggalLahir,
    String? jenisKelamin,
    String? pekerjaan,
    String? status,
    String? alamatRT005,
    String? alamatKTP,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      nomorKK: nomorKK ?? this.nomorKK,
      nomorNIK: nomorNIK ?? this.nomorNIK,
      tempatLahir: tempatLahir ?? this.tempatLahir,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      pekerjaan: pekerjaan ?? this.pekerjaan,
      status: status ?? this.status,
      alamatRT005: alamatRT005 ?? this.alamatRT005,
      alamatKTP: alamatKTP ?? this.alamatKTP,
      role: role ?? this.role,
    );
  }
}
