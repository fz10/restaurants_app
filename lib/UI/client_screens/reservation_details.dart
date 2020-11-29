import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurants_app/blocs/client_reservation_details/bloc/client_reservation_details_bloc.dart';
import 'package:restaurants_app/blocs/client_reservations/bloc/client_reservations_bloc.dart';
import 'package:restaurants_app/models/models.dart';
import 'package:restaurants_app/repositories/user_repository.dart';
import 'package:restaurants_app/resources/style.dart';

class ReservationDetails extends StatefulWidget {
  final UserRepository _userRepository;
  final Client _user;
  final Reservation _reservation;

  const ReservationDetails(
      {Key key, @required userRepository, Client user, Reservation reservation})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _user = user,
        _reservation = reservation,
        super();

  @override
  _ReservationDetailsState createState() => _ReservationDetailsState();
}

class _ReservationDetailsState extends State<ReservationDetails> {
  UserRepository get _userRepository => widget._userRepository;
  Client get _user => widget._user;
  Reservation get _reservation => widget._reservation;

  ClientReservationDetailsBloc _detailsBloc;

  @override
  void initState() {
    super.initState();
    _detailsBloc =
        ClientReservationDetailsBloc(userRepository: _userRepository);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => _moveToLastScreen(context),
        ),
        title: Text('Detalles de la reserva'),
        centerTitle: true,
        backgroundColor: brandColor,
      ),
      body: BlocProvider(
        create: (context) => _detailsBloc,
        child: BlocListener(
          cubit: _detailsBloc,
          listener: (BuildContext context, ClientReservationDetailsState state) {
            if (state is SuccessState) {
              _showSuccessDialog();
              Navigator.of(context).pop();
            } else if (state is FailureState) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          child: _screenContent(),
        ),
      ),
    );
  }

  Widget _screenContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Column(
              children: [
                Text(_reservation.restName, style: restNameStyle),
                Divider(color: Colors.grey, thickness: 2)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event,
                      size: 40,
                    ),
                    Text('Fecha: ', style: subTitle),
                    Text(_reservation.date, style: subTitle2)
                  ],
                ),
                Divider(color: Colors.grey, thickness: 2),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time, size: 30),
                      Text('Desde', style: subTitle2),
                    ],
                  ),
                  Text(_reservation.inTime, style: TextStyle(fontSize: 25)),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time, size: 30),
                      Text('Hasta', style: subTitle2),
                    ],
                  ),
                  Text(_reservation.outTime, style: TextStyle(fontSize: 25)),
                ],
              ),
            ],
          ),
          Divider(color: Colors.grey, thickness: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Orden', style: subTitle2),
              Text('Mesas: ${_reservation.tables}', style: subTitle2),
            ],
          ),
          (_reservation.order != null)
              ? _showOrderDetails(context)
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                      child: Text('Realiza tu orden en el lugar',
                          style: TextStyle(fontSize: 25))),
                ),
          (_reservation.order != null)
              ? Text(
                  'Total: \$ ${_reservation.order['total']}',
                  style: subTitle2,
                  textAlign: TextAlign.end,
                )
              : Container(),
          SizedBox(
            height: 60,
          ),
          (_reservation.state == 'activa')
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _showState(),
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: RaisedButton(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        onPressed: _onCancelSubmitted,
                        child: Row(
                          children: [
                            Icon(Icons.close, size: 30, color: Colors.white),
                            Text('Cancelar',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20))
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : _showState(),
        ],
      ),
    );
  }

  Icon _getStateIcon(String state) {
    if (state == 'activa') {
      return Icon(Icons.alarm_on, size: 50, color: Colors.blue);
    } else if (state == 'confirmada') {
      return Icon(Icons.check_circle, size: 50, color: Colors.green);
    } else {
      return Icon(Icons.cancel, size: 50, color: Colors.red);
    }
  }

  Widget _showOrderDetails(BuildContext context) {
    List order = _reservation.order['items'];

    return Container(
      height: 150,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        itemCount: order.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> item = order[index];
          return Container(
            width: 200,
            child: Card(
              shape: cardShape,
              color: Colors.white,
              elevation: 10,
              child: ListTile(
                shape: cardShape,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                title: Text(
                  item['item'],
                  style: cardTitleStyle,
                ),
                subtitle: Text(
                  'Precio: \$ ${item['price']} X ${item['quantity']}',
                  style: cardSubtytleStyle,
                ),
                onTap: () {},
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _showState() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _getStateIcon(_reservation.state),
        Text(_reservation.state, style: subTitle2)
      ],
    );
  }

  Future _onCancelSubmitted() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                '¿Se cancelará la reserva en el restaurante, desea continuar?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  _detailsBloc.add(CanceledEvent(
                      id: _reservation.id, newState: 'cancelada'));
                  Navigator.pop(context);
                },
                child: Text('Aceptar'),
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar')),
            ],
          );
        });
  }

  Future _showSuccessDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          Future.delayed(Duration(milliseconds: 1500), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            elevation: 10,
            shape: cardShape,
            title: Center(child: Text('¡Reserva cancelada exitosamente!', textAlign: TextAlign.center)),
            content: Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
          );
        });
  }

  void _moveToLastScreen(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _detailsBloc.close();
    super.dispose();
  }
}
