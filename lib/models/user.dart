class UserModel{
  final String username;
  final int jenisUser;
  final String token;
  final int canBuy;

  UserModel({
    this.username = '',
    this.jenisUser = -1,
    this.token = '',
    this.canBuy = 0
  });

  UserModel copyWith({
    String ?username,
    int ?jenisUser,
    String ?token,
    int ?canBuy
  }){
    return UserModel(
      username:username ?? this.username,
      jenisUser:jenisUser ?? this.jenisUser,
      token:token ?? this.token,
      canBuy: canBuy ?? this.canBuy
    );
  }

}