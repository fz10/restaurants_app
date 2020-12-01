part of 'restaurant_reservation_details_bloc.dart';

abstract class RestaurantReservationDetailsEvent extends Equatable {
  const RestaurantReservationDetailsEvent();

  @override
  List<Object> get props => [];
}

class CanceledEvent extends RestaurantReservationDetailsEvent {
  final String id;
  final String newState;

  CanceledEvent({@required this.id, @required this.newState});

  @override
  String toString() => 'CanceledEvent';
}

class ConfirmedEvent extends RestaurantReservationDetailsEvent {
  final String id;
  final String newState;

  ConfirmedEvent({@required this.id, @required this.newState});

  @override
  String toString() => 'ConfirmedEvent';
}
