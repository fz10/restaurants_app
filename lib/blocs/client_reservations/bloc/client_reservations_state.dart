part of 'client_reservations_bloc.dart';

abstract class ClientReservationsState extends Equatable {
  const ClientReservationsState();
  
  @override
  List<Object> get props => [];
}

class ClientReservationsInitial extends ClientReservationsState {}
