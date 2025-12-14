import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_gasku/models/detail_pembelian.dart';

class DetailPembelianNotifier extends Notifier<DetailPembelianModel> {
  @override
  DetailPembelianModel build() {
    return DetailPembelianModel(); // Default kosong
  }

  // Fungsi untuk update data transaksi baru dari response API
  void setTransaksiBaru({
    required int jumlah,
    required int total,
    required String tanggalString,
  }) {
    state = state.copyWith(
      jumlahPembelian: jumlah,
      totalHarga: total,
      tanggalFormatted: tanggalString, // Menyimpan string dari Carbon controller
      status: 'Menunggu Pembayaran'
    );
  }

  // Reset data jika diperlukan
  void clear() {
    state = DetailPembelianModel();
  }
}

// Global Provider
final DetailPembelianProvider = NotifierProvider<DetailPembelianNotifier, DetailPembelianModel>(() {
  return DetailPembelianNotifier();
});