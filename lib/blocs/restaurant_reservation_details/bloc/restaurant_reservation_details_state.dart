part of 'restaurant_reservation_details_bloc.dart';

abstract class RestaurantReservationDetailsState extends Equatable {
  const RestaurantReservationDetailsState();

  @override
  List<Object> get props => [];
}

class RestaurantReservationDetailsInitial
    extends RestaurantReservationDetailsState {}

class SuccessState extends RestaurantReservationDetailsState {
  final String message;

  SuccessState({@required this.message});

  @override
  String toString() => 'Success';
}

class FailureState extends RestaurantReservationDetailsState {
  final String message;

  FailureState({@required this.message});

  @override
  String toString() => 'Failure';
}
