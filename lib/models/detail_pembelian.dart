class DetailPembelianModel {
  final int idTransaksi;
  final int idUser;
  final int idGas;
  final int jumlahPembelian;
  final String status;
  final DateTime tanggalTransaksi;
  // Field tambahan untuk menampung response Controller
  final int totalHarga; 
  final String tanggalFormatted; 

  DetailPembelianModel({
    this.idTransaksi = 0,
    this.idUser = 0,
    this.idGas = 0,
    this.jumlahPembelian = 0,
    this.status = 'Menunggu Pembayaran',
    DateTime? tanggalTransaksi,
    this.totalHarga = 0,
    this.tanggalFormatted = '',
  }) : this.tanggalTransaksi = tanggalTransaksi ?? DateTime.now();

  // Method copyWith untuk update state
  DetailPembelianModel copyWith({
    int? idTransaksi,
    int? idUser,
    int? idGas,
    int? jumlahPembelian,
    String? status,
    DateTime? tanggalTransaksi,
    int? totalHarga,
    String? tanggalFormatted,
  }) {
    return DetailPembelianModel(
      idTransaksi: idTransaksi ?? this.idTransaksi,
      idUser: idUser ?? this.idUser,
      idGas: idGas ?? this.idGas,
      jumlahPembelian: jumlahPembelian ?? this.jumlahPembelian,
      status: status ?? this.status,
      tanggalTransaksi: tanggalTransaksi ?? this.tanggalTransaksi,
      totalHarga: totalHarga ?? this.totalHarga,
      tanggalFormatted: tanggalFormatted ?? this.tanggalFormatted,
    );
  }
}