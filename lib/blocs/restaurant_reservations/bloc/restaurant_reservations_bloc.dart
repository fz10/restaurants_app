import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:restaurants_app/models/models.dart';
import 'package:restaurants_app/repositories/user_repository.dart';

part 'restaurant_reservations_event.dart';
part 'restaurant_reservations_state.dart';

class RestaurantReservationsBloc
    extends Bloc<RestaurantReservationsEvent, RestaurantReservationsState> {
  UserRepository _userRepository;

  RestaurantReservationsBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(RestaurantReservationsInitial());

  @override
  Stream<RestaurantReservationsState> mapEventToState(
    RestaurantReservationsEvent event,
  ) async* {
    if (event is LoadReservations) {
      yield* _mapLoadReservationsToState(event.restId);
    }
  }

  Stream<RestaurantReservationsState> _mapLoadReservationsToState(
      String restId) async* {
        yield LoadingReservations();
    try {
      final reservationList = await _userRepository.getAllReservationsByRestaurant(restId);
      reservationList.sort((a, b) => a.priority.compareTo(b.priority));
      if (reservationList.isNotEmpty) {
        yield Success(reservationList: reservationList);
      } else {
        yield (NoResults(message: 'No tienes reservas'));
      }
    } catch (e) {
      yield Failure(message: 'Error al cargar reservas');
      print('Error is: $e');
    }
      }
}
