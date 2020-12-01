import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:restaurants_app/repositories/user_repository.dart';

part 'restaurant_reservation_details_event.dart';
part 'restaurant_reservation_details_state.dart';

class RestaurantReservationDetailsBloc extends Bloc<
    RestaurantReservationDetailsEvent, RestaurantReservationDetailsState> {
  UserRepository _userRepository;

  RestaurantReservationDetailsBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(RestaurantReservationDetailsInitial());

  @override
  Stream<RestaurantReservationDetailsState> mapEventToState(
    RestaurantReservationDetailsEvent event,
  ) async* {
    if (event is ConfirmedEvent) {
      yield* _mapConfirmedEventToState(event.id, event.newState);
    } else if (event is CanceledEvent) {
      yield* _mapCanceledEventToState(event.id, event.newState);
    }
  }

  Stream<RestaurantReservationDetailsState> _mapConfirmedEventToState(
      String id, String newState) async* {
    try {
      await _userRepository.changeReservationState(id, newState, 1);
      yield SuccessState(message: 'confirmada');
    } catch (e) {
      yield FailureState(message: 'Error al confirmar reserva');
      print('Error is $e');
    }
  }

  Stream<RestaurantReservationDetailsState> _mapCanceledEventToState(
      String id, String newState) async* {
    try {
      await _userRepository.changeReservationState(id, newState, 2);
      yield SuccessState(message: 'cancelada');
    } catch (e) {
      yield FailureState(message: 'Error al cancelar reserva');
      print('Error is $e');
    }
  }
}
