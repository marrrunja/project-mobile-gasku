import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_gasku/models/user.dart';

class UserNotifier extends Notifier<UserModel> {
  @override
  UserModel build() {
    return UserModel(); // default kosong
  }

  // Update semua data user
  void updateAll({
    required String username,
    required int jenisUser,
    required String token,
    required int canBuy
  }) {
    state = UserModel(
      username: username,
      jenisUser: jenisUser,
      token: token,
      canBuy: canBuy
    );
  }

  // Clear / reset data user (misal saat logout)
  void clear() {
    state = UserModel(); // kembalikan ke default kosong
  }
}

// Provider
final UserProvider = NotifierProvider<UserNotifier, UserModel>(() {
  return UserNotifier();
});
