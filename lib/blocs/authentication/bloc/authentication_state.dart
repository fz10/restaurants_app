part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {
  @override
  String toString() => 'Uninitialized';
}

class AuthenticatedClient extends AuthenticationState {
  final Client user;

  AuthenticatedClient({this.user}) : super([user]);

  @override
  String toString() => 'Authenticated client';
}

class AuthenticatedRestaurant extends AuthenticationState {
  final Restaurant restaurant;

  AuthenticatedRestaurant({this.restaurant}) : super([restaurant]);

  @override
  String toString() => 'Authenticated client';
}

class NotMenu extends AuthenticationState {
  final Restaurant restaurant;

  NotMenu(this.restaurant) : super([restaurant]);

  @override
  String toString() => 'Not Menu';
}

class Loading extends AuthenticationState {
  @override
  String toString() => 'Loading';
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => 'Unauthenticated';
}
