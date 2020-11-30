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
  List<Map<String, dynamic>> _order;
  double _total;

  MakeReservationBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository,
        _order = List<Map<String, dynamic>>(),
        _total = 0,
        super(MakeReservationInitial(
          order: List<Map<String, dynamic>>(),
          total: 0,
        ));

  @override
  Stream<MakeReservationState> mapEventToState(
    MakeReservationEvent event,
  ) async* {
    if (event is Update) {
      yield* _mapUpdateToState(event.item);
    } else if (event is SubmittedNotMenu) {
      yield* _mapSubmittedNotMenuToState(event);
    } else if (event is SubmittedWithMenu) {
      yield* _mapSubmittedWithMenuToState(event);
    }
  }

  Stream<MakeReservationState> _mapUpdateToState(
      Map<String, dynamic> item) async* {
    yield LoadingReservation(order: _order, total: _total);
    try {
      _order.add(item);
      _total = 0;
      _order.forEach((element) {
        _total += (element['price'] * element['quantity']);
      });
      yield Updated(order: _order, total: _total);
    } catch (e) {
      yield Failure(
          order: _order, total: _total, message: 'Error añadiendo producto');
      print('Error is: $e');
    }
  }

  Stream<MakeReservationState> _mapSubmittedNotMenuToState(
      SubmittedNotMenu event) async* {
    yield (LoadingReservation(order: _order, total: _total));
    try {
      await _userRepository.addReservation(Reservation(
        date: event.date,
        inTime: event.from,
        outTime: event.until,
        restId: event.restaurant.id,
        restName: event.restaurant.name,
        tables: (event.people / 5).ceil(),
        userId: event.user.id,
        userName: event.user.name,
        userEmail: event.user.email,
        state: 'Activa',
        priority: 0,
      ));
      yield (Success(order: _order, total: _total));
    } catch (e) {
      yield Failure(order: _order, total: _total, message: 'Error de reserva');
      print('Error is:$e');
    }
  }

  Stream<MakeReservationState> _mapSubmittedWithMenuToState(
      SubmittedWithMenu event) async* {
    yield (LoadingReservation(order: _order, total: _total));
    try {
      await _userRepository.addReservation(Reservation(
        date: event.date,
        inTime: event.from,
        outTime: event.until,
        order: {'items': _order, 'total': _total},
        restId: event.restaurant.id,
        restName: event.restaurant.name,
        tables: (event.people / 5).ceil(),
        userId: event.user.id,
        userName: event.user.name,
        userEmail: event.user.email,
        state: 'Activa',
        priority: 0,
      ));
      yield (Success(order: _order, total: _total));
    } catch (e) {
      yield Failure(order: _order, total: _total, message: 'Error de reserva');
      print('Error is:$e');
    }
  }
}
