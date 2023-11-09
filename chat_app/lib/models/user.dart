class User {
  String username = "";
  String email;
  String password;
  String token = "";
  String firebaseToken = "";
  String uuid = "";

  User({required this.email,
    required this.password,
    this.username = "",
    this.token = "",
    this.firebaseToken = "",
    this.uuid = ""
  });
}