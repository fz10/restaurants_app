import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:restaurants_app/models/models.dart';
import 'package:restaurants_app/repositories/user_repository.dart';

part 'make_reservation_event.dart';
part 'make_reservation_state.dart';

class MakeReservationBloc
    extends Bloc<MakeReservationEvent, MakeReservationState> {
  UserRepository _userRepository;
  List<Map<String, dynamic>> _menu;
  double _total;

  MakeReservationBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository,
        _menu = List<Map<String, dynamic>>(),
        _total = 0,
        super(MakeReservationInitial(
          menu: List<Map<String, dynamic>>(),
          total: 0,
        ));

  @override
  Stream<MakeReservationState> mapEventToState(
    MakeReservationEvent event,
  ) async* {}
}
