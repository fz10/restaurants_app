part of 'client_register_bloc.dart';

@immutable
abstract class RegisterEvent extends Equatable {
  RegisterEvent([List props = const []]) : super([props]);
}

class EmailChanged extends RegisterEvent {
  final String email;

  EmailChanged({@required this.email}) : super([email]);

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class PasswordChanged extends RegisterEvent {
  final String password;

  PasswordChanged({@required this.password}) : super([password]);

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class Submitted extends RegisterEvent {
  final Client client;
  final String email;
  final String password;

  Submitted(
      {@required this.client, @required this.email, @required this.password})
      : super([client, email, password]);

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password }';
  }
}
