class AuthEvent {}

class AuthEventLogin extends AuthEvent {
  String? login;
  String? password;
  AuthEventLogin({required this.login, required this.password});
}

class AuthEventRegister extends AuthEvent {
  String? firstName;
  String? phone;
  String? email;
  String? password;
  AuthEventRegister(
      {required this.firstName,
      required this.phone,
      required this.email,
      required this.password});
}
