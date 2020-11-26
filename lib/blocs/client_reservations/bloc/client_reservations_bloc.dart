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
  ) async* {}
}
