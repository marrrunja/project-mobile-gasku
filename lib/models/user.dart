class UserModel{
  final String username;
  final int jenisUser;
  final String token;

  UserModel({
    this.username = '',
    this.jenisUser = -1,
    this.token = '',
  });

  UserModel copyWith({
    String ?username,
    int ?jenisUser,
    String ?token
  }){
    return UserModel(
      username:username ?? this.username,
      jenisUser:jenisUser ?? this.jenisUser,
      token:token ?? this.token
    );
  }

}