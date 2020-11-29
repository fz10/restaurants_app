import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:restaurants_app/repositories/user_repository.dart';

part 'client_reservation_details_event.dart';
part 'client_reservation_details_state.dart';

class ClientReservationDetailsBloc
    extends Bloc<ClientReservationDetailsEvent, ClientReservationDetailsState> {
  UserRepository _userRepository;

  ClientReservationDetailsBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(ClientReservationDetailsInitial());

  @override
  Stream<ClientReservationDetailsState> mapEventToState(
    ClientReservationDetailsEvent event,
  ) async* {
    if (event is CanceledEvent) {
      yield* _mapCanceledEventToState(event.id, event.newState);
    }
  }

  Stream<ClientReservationDetailsState> _mapCanceledEventToState(
      String id, String newState) async* {
    try {
      await _userRepository.changeReservationState(id, newState);
      yield SuccessState();
    } catch (e) {
      yield FailureState(message: 'Error al cancelar reserva');
      print('Error is $e');
    }
  }
}
