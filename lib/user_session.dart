class UserSession {
  UserSession._internal();
  static final UserSession instance = UserSession._internal();

  String? username;
  String? token;
}