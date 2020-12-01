import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurants_app/blocs/restaurant_reservation_details/bloc/restaurant_reservation_details_bloc.dart';
import 'package:restaurants_app/models/models.dart';
import 'package:restaurants_app/repositories/user_repository.dart';
import 'package:restaurants_app/resources/style.dart';

class RestaurantReservationDetails extends StatefulWidget {
  final UserRepository _userRepository;
  final Reservation _reservation;

  const RestaurantReservationDetails(
      {Key key, @required userRepository, Reservation reservation})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _reservation = reservation,
        super();

  @override
  _RestaurantReservationDetailsState createState() =>
      _RestaurantReservationDetailsState();
}

class _RestaurantReservationDetailsState
    extends State<RestaurantReservationDetails> {
  UserRepository get _userRepository => widget._userRepository;
  Reservation get _reservation => widget._reservation;

  RestaurantReservationDetailsBloc _detailsBloc;

  @override
  void initState() {
    super.initState();
    _detailsBloc =
        RestaurantReservationDetailsBloc(userRepository: _userRepository);
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
          listener: (context, state) {
            if (state is SuccessState) {
              _showSuccessDialog(state.message);
              Navigator.of(context).pop();
            } else if (state is SuccessState) {
              _showSuccessDialog('confirmada');
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
                Text(_reservation.userName, style: subTitle),
                Text(_reservation.userEmail, style: TextStyle(fontSize: 25)),
                Divider(color: Colors.grey, thickness: 2)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event,
                      size: 30,
                    ),
                    Text('Fecha: ',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(_reservation.date,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))
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
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.end,
                )
              : Container(),
          SizedBox(
            height: 20,
          ),
          (_reservation.state == 'Activa')
              ? Column(
                  children: [
                    _showState(),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 155,
                          child: RaisedButton(
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            onPressed: _onConfirmedSubmitted,
                            child: Row(
                              children: [
                                Icon(Icons.check,
                                    size: 30, color: Colors.white),
                                Text('Confirmar',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 155,
                          child: RaisedButton(
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            onPressed: _onCancelSubmitted,
                            child: Row(
                              children: [
                                Icon(Icons.close,
                                    size: 30, color: Colors.white),
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
                    ),
                  ],
                )
              : _showState(),
        ],
      ),
    );
  }

  Icon _getStateIcon(String state) {
    if (state == 'Activa') {
      return Icon(Icons.alarm_on, size: 50, color: Colors.blue);
    } else if (state == 'Confirmada') {
      return Icon(Icons.check_circle, size: 50, color: Colors.green);
    } else {
      return Icon(Icons.cancel, size: 50, color: Colors.red);
    }
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

  Future _onConfirmedSubmitted() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('¿Desea confirmar la llegada del cliente?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  _detailsBloc.add(ConfirmedEvent(
                      id: _reservation.id, newState: 'Confirmada'));
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

  Future _onCancelSubmitted() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                'Se cancelará la reserva en el restaurante, ¿desea continuar?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  _detailsBloc.add(CanceledEvent(
                      id: _reservation.id, newState: 'Cancelada'));
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

  Future _showSuccessDialog(String message) {
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
            title: Center(
                child: Text('¡Reserva $message exitosamente!',
                    textAlign: TextAlign.center)),
            content:
                Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
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
