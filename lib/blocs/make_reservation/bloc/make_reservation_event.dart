part of 'make_reservation_bloc.dart';

abstract class MakeReservationEvent extends Equatable {
  const MakeReservationEvent();

  @override
  List<Object> get props => [];
}

class Update extends MakeReservationEvent {
  final Map<String, dynamic> item;

  Update({@required this.item});

  @override
  String toString() => 'Update';
}

class SubmittedNotMenu extends MakeReservationEvent {
  final String date;
  final String from;
  final String until;
  final int people;
  final Restaurant restaurant;
  final Client user;

  SubmittedNotMenu(
      {@required this.date,
      @required this.from,
      @required this.until,
      @required this.people,
      @required this.restaurant,
      @required this.user});
}

class SubmittedWithMenu extends MakeReservationEvent {
  final String date;
  final String from;
  final String until;
  final int people;
  final Restaurant restaurant;
  final Client user;

  SubmittedWithMenu(
      {@required this.date,
      @required this.from,
      @required this.until,
      @required this.people,
      @required this.restaurant,
      @required this.user});
}
