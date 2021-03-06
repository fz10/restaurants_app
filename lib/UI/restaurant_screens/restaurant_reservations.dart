import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurants_app/UI/restaurant_screens/restaurant_reservation_details.dart';
import 'package:restaurants_app/blocs/restaurant_reservations/bloc/restaurant_reservations_bloc.dart';
import 'package:restaurants_app/models/models.dart';
import 'package:restaurants_app/repositories/user_repository.dart';
import 'package:restaurants_app/resources/style.dart';

class RestaurantReservations extends StatefulWidget {
  final UserRepository _userRepository;
  final Restaurant _restaurant;

  const RestaurantReservations(
      {Key key, @required userRepository, Restaurant restaurant})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _restaurant = restaurant,
        super();

  @override
  _RestaurantReservationsState createState() => _RestaurantReservationsState();
}

class _RestaurantReservationsState extends State<RestaurantReservations> {
  UserRepository get _userRepository => widget._userRepository;
  Restaurant get _restaurant => widget._restaurant;
  List<Reservation> reservationList;

  RestaurantReservationsBloc _reservationsBloc;

  @override
  void initState() {
    super.initState();
    _reservationsBloc =
        RestaurantReservationsBloc(userRepository: _userRepository);
    _reservationsBloc.add(LoadReservations(restId: _restaurant.id));
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Reservas de clientes'),
                  centerTitle: true,
                  backgroundColor: brandColor,
                ),
                body: BlocProvider(
                  create: (context) => _reservationsBloc,
                  child: BlocListener(
                    cubit: _reservationsBloc,
                    listener: (context, state) {
                      if (state is Failure) {
                        Scaffold.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(state.message),
                                  Icon(Icons.error),
                                ],
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                      }
                    },
                    child: BlocBuilder(
                      cubit: _reservationsBloc,
                      builder: (context, state) {
                        if (state is Success) {
                          return _getReservationListView(state.reservationList);
                        } else if (state is LoadingReservations) {
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 100),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (state is NoResults) {
                          return Container(
                            margin: EdgeInsets.all(70),
                            child: Center(
                                child: Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                            )),
                          );
                        } else if (state is Failure) {
                          return _defaultContent();
                        } else {
                          return _defaultContent();
                        }
                      },
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

  Widget _getReservationListView(List<Reservation> reservationList) {
    return RefreshIndicator(
      onRefresh: () async =>
          _reservationsBloc.add(LoadReservations(restId: _restaurant.id)),
      child: ListView.builder(
        itemCount: reservationList.length,
        itemBuilder: (BuildContext context, int position) {
          Reservation reservation = reservationList[position];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Card(
              shape: cardShape,
              color: Colors.white,
              elevation: 10,
              child: ListTile(
                shape: cardShape,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                title: Center(
                  child: Text(
                    reservation.userName,
                    style: cardTitleStyle,
                  ),
                ),
                subtitle: Column(
                  children: [
                    Text(
                      'Fecha: ${reservation.date}',
                      style: cardSubtytleStyle,
                    ),
                    Text('${reservation.inTime} - ${reservation.outTime}',
                        style: cardSubtytleStyle),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _getStateIcon(reservation.state),
                            SizedBox(width: 5),
                            Text(reservation.state, style: cardSubtytleStyle)
                          ],
                        ),
                        Text('Mesas: ${reservation.tables}',
                            style: cardSubtytleStyle)
                      ],
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.book,
                  color: Colors.grey,
                  size: 50,
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return RestaurantReservationDetails(
                          userRepository: _userRepository,
                          reservation: reservation);
                    },
                  ));
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _defaultContent() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 150, horizontal: 40),
      child: Center(
        child: Text(
          '¡Lista de tus reservas!',
          style: searchScreenTextStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Icon _getStateIcon(String state) {
    if (state == 'Activa') {
      return Icon(Icons.alarm_on, size: 40, color: Colors.blue);
    } else if (state == 'Confirmada') {
      return Icon(Icons.check_circle, size: 30, color: Colors.green);
    } else {
      return Icon(Icons.cancel, size: 30, color: Colors.red);
    }
  }

  @override
  void dispose() {
    _reservationsBloc.close();
    super.dispose();
  }
}
