import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_gasku/models/user.dart';

class UserNotifier extends Notifier<UserModel>{
  @override
  UserModel build() {
    return UserModel();
  }

  void updateAll({
    required String username,
    required int jenisUser,
    required String token
  }){
    state = UserModel(
      username: username,
      jenisUser: jenisUser,
      token: token
    );
  }
}
final UserProvider = NotifierProvider<UserNotifier, UserModel>((){
  return UserNotifier();
});