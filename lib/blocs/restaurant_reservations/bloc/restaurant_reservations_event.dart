part of 'restaurant_reservations_bloc.dart';

abstract class RestaurantReservationsEvent extends Equatable {
  const RestaurantReservationsEvent();

  @override
  List<Object> get props => [];
}

class LoadReservations extends RestaurantReservationsEvent {
  final String restId;

  LoadReservations({@required this.restId});

  @override
  String toString() => 'LoadReservations';
}
