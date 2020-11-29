part of 'client_reservations_bloc.dart';

abstract class ClientReservationsEvent extends Equatable {
  const ClientReservationsEvent();

  @override
  List<Object> get props => [];
}

class LoadReservations extends ClientReservationsEvent {
  String userId;

  LoadReservations({@required this.userId});

  @override
  String toString() => 'LoadReservations';
}
