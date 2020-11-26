import 'package:flutter/material.dart';
import 'package:restaurants_app/blocs/client_reservations/bloc/client_reservations_bloc.dart';
import 'package:restaurants_app/models/models.dart';
import 'package:restaurants_app/repositories/user_repository.dart';

class Reservations extends StatefulWidget {
  final UserRepository _userRepository;
  final Client _user;

  const Reservations({Key key, @required userRepository, Client user})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _user = user,
        super();

  @override
  _ReservationsState createState() => _ReservationsState();
}

class _ReservationsState extends State<Reservations> {
  UserRepository get _userRepository => widget._userRepository;
  Client get _user => widget._user;
  List<Reservation> reservationList;

  ClientReservationsBloc _reservationsBloc;

  @override
  void initState() {
    super.initState();
    _reservationsBloc = ClientReservationsBloc(userRepository: _userRepository);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Reservations screen!'),
      ),
    );
  }
}
