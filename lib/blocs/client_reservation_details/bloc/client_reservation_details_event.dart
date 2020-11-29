part of 'client_reservation_details_bloc.dart';

abstract class ClientReservationDetailsEvent extends Equatable {
  const ClientReservationDetailsEvent();

  @override
  List<Object> get props => [];
}

class CanceledEvent extends ClientReservationDetailsEvent {
  final String id;
  final String newState;

  CanceledEvent({@required this.id, @required this.newState});

  @override
  String toString() => 'CanceledEvent';
}
