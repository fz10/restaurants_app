part of 'restaurant_reservations_bloc.dart';

abstract class RestaurantReservationsState extends Equatable {
  const RestaurantReservationsState();
  
  @override
  List<Object> get props => [];
}

class RestaurantReservationsInitial extends RestaurantReservationsState {}

class LoadingReservations extends RestaurantReservationsState {}

class Failure extends RestaurantReservationsState {
  final String message;

  Failure({@required this.message});

  @override
  String toString() => 'Failure';
}

class NoResults extends RestaurantReservationsState {
  final String message;

  NoResults({@required this.message});

  @override
  String toString() => 'NoResults';
}

class Success extends RestaurantReservationsState {
  final List<Reservation> reservationList;

  Success({@required this.reservationList});

  @override
  String toString() => 'Success';
}