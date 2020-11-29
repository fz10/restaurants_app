part of 'client_reservations_bloc.dart';

abstract class ClientReservationsState extends Equatable {
  const ClientReservationsState();

  @override
  List<Object> get props => [];
}

class ClientReservationsInitial extends ClientReservationsState {}

class LoadingReservations extends ClientReservationsState {}

class Failure extends ClientReservationsState {
  final String message;

  Failure({@required this.message});

  @override
  String toString() => 'Failure';
}

class NoResults extends ClientReservationsState {
  final String message;

  NoResults({@required this.message});

  @override
  String toString() => 'NoResults';
}

class Success extends ClientReservationsState {
  final List<Reservation> reservationList;

  Success({@required this.reservationList});

  @override
  String toString() => 'Success';
}
