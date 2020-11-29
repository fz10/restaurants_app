import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:restaurants_app/models/models.dart';
import 'package:restaurants_app/repositories/user_repository.dart';

part 'client_reservations_event.dart';
part 'client_reservations_state.dart';

class ClientReservationsBloc
    extends Bloc<ClientReservationsEvent, ClientReservationsState> {
  UserRepository _userRepository;
  List<Reservation> _reservationList;

  ClientReservationsBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository,
        super(ClientReservationsInitial());

  @override
  Stream<ClientReservationsState> mapEventToState(
    ClientReservationsEvent event,
  ) async* {
    if (event is LoadReservations) {
      yield* _mapLoadReservationsToState(event.userId);
    }
  }

  Stream<ClientReservationsState> _mapLoadReservationsToState(
      String userId) async* {
    yield LoadingReservations();
    try {
      final reservationList = await _userRepository.getAllReservations(userId);
      this._reservationList = reservationList;
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
