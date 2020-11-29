part of 'client_reservation_details_bloc.dart';

abstract class ClientReservationDetailsState extends Equatable {
  const ClientReservationDetailsState();

  @override
  List<Object> get props => [];
}

class ClientReservationDetailsInitial extends ClientReservationDetailsState {}

class SuccessState extends ClientReservationDetailsState {
  @override
  String toString() => 'Success';
}

class FailureState extends ClientReservationDetailsState {
  final String message;

  FailureState({@required this.message});

  @override
  String toString() => 'Failure';
}
