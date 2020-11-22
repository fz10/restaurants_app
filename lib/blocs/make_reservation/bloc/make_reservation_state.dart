part of 'make_reservation_bloc.dart';

abstract class MakeReservationState extends Equatable {
  const MakeReservationState();

  @override
  List<Object> get props => [];
}

class MakeReservationInitial extends MakeReservationState {
  final List<Map<String, dynamic>> menu;
  final double total;

  MakeReservationInitial({@required this.menu, @required this.total});

  @override
  String toString() => 'MakeReservationInitial';
}

class Updated extends MakeReservationState {
  final List<Map<String, dynamic>> menu;
  final double total; 

  Updated({@required this.menu, @required this.total});

  @override
  String toString() => 'Updated';
}

class Success extends MakeReservationState {
  final List<Map<String, dynamic>> menu;
  final double total;

  Success({@required this.menu, @required this.total});

  @override
  String toString() => 'Success';
}

class Failure extends MakeReservationState {
  final List<Map<String, dynamic>> menu;
  final double total;

  Failure({@required this.menu, @required this.total});

  @override
  String toString() => 'Failure';
}

class LoadingReservation extends MakeReservationState {
  final List<Map<String, dynamic>> menu;
  final double total;

  LoadingReservation({@required this.menu, @required this.total});

  @override
  String toString() => 'LoadingReservation';
}
