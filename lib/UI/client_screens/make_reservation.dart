import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:restaurants_app/blocs/make_reservation/bloc/make_reservation_bloc.dart';
import 'package:restaurants_app/models/models.dart';
import 'package:restaurants_app/repositories/user_repository.dart';
import 'package:restaurants_app/resources/style.dart';
import 'package:string_validator/string_validator.dart';

class MakeReservation extends StatefulWidget {
  final UserRepository _userRepository;
  final Client _user;
  final Restaurant _restaurant;

  const MakeReservation(
      {Key key, @required userRepository, Client user, Restaurant restaurant})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _user = user,
        _restaurant = restaurant,
        super(key: key);

  @override
  _MakeReservationState createState() => _MakeReservationState();
}

class _MakeReservationState extends State<MakeReservation> {
  UserRepository get _userRepository => widget._userRepository;
  Client get _user => widget._user;
  Restaurant get _restaurant => widget._restaurant;

  MakeReservationBloc _makeReservationBloc;

  String _date;
  String _from;
  String _until;
  int _people;

  @override
  void initState() {
    super.initState();
    _makeReservationBloc = MakeReservationBloc(userRepository: _userRepository);
    _date = '----';
    _from = '--';
    _until = '--';
    _people = 0;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _moveToLastScreen(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => _moveToLastScreen(context),
          ),
          title: Text('Personalizar reserva'),
          centerTitle: true,
          backgroundColor: brandColor,
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.check, color: Colors.white, size: 30),
          label: Text('Reservar',
              style: TextStyle(color: Colors.white, fontSize: 15)),
          onPressed: () {
            if (_date != '----' &&
                _from != '--' &&
                _until != '--' &&
                _people > 0) {
              _makeReservationBloc.add(SubmittedWithMenu(
                  date: _date,
                  from: _from,
                  until: _until,
                  people: _people,
                  restaurant: _restaurant,
                  user: _user));
            }
          },
        ),
        body: BlocProvider(
          create: (context) => _makeReservationBloc,
          child: BlocListener(
            cubit: _makeReservationBloc,
            listener: (context, state) {
              if (state is Success) {
                _showSuccessDialog();
                Navigator.of(context)..pop()..pop();
              } else if (state is Failure) {
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
            child: BlocBuilder(
                cubit: _makeReservationBloc,
                builder: (BuildContext context, MakeReservationState state) {
                  if (state is MakeReservationInitial) {
                    return showScreenContent(context);
                  } else if (state is Updated) {
                    return Column(
                      children: [
                        showOrderDetails(context, state.order, state.total),
                        Expanded(child: showScreenContent(context)),
                      ],
                    );
                  } else {
                    return showScreenContent(context);
                  }
                }),
          ),
        ),
      ),
    );
  }

  Widget showScreenContent(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          sliver: SliverToBoxAdapter(
            child: Card(
              shape: menuCardShape,
              color: Colors.white,
              elevation: 10,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  showDatePicker(
                    context: context,
                    locale: const Locale('es', 'ES'),
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context),
                        child: child,
                      );
                    },
                  ).then((date) {
                    setState(() {
                      _date = DateFormat('dd-MM-yyyy').format(date);
                    });
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Fecha de reserva: ',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(_date, style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Card(
                    shape: menuCardShape,
                    color: Colors.white,
                    elevation: 10,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        DatePicker.showTimePicker(
                          context,
                          currentTime: DateTime.parse('2021-02-27 12:00:00'),
                          showSecondsColumn: false,
                          onConfirm: (time) {
                            setState(() {
                              _from = DateFormat.Hm().format(time);
                            });
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Desde: ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text(_from, style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    shape: menuCardShape,
                    color: Colors.white,
                    elevation: 10,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        DatePicker.showTimePicker(
                          context,
                          currentTime: DateTime.parse('2021-02-27 12:00:00'),
                          showSecondsColumn: false,
                          onConfirm: (time) {
                            setState(() {
                              _until = DateFormat.Hm().format(time);
                            });
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Hasta: ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text(_until, style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(top: 10),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: Text(
                'Personas',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: FloatingActionButton(
                  elevation: 5,
                  backgroundColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      _people > 0 ? _people -= 1 : _people = _people;
                    });
                  },
                  child: Icon(Icons.remove, size: 40, color: brandColor),
                )),
                Text(_people.toString(), style: subTitle2),
                Expanded(
                    child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      _people += 1;
                    });
                  },
                  child: Icon(Icons.add, size: 40, color: brandColor),
                )),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          sliver: SliverToBoxAdapter(
              child: Divider(color: Colors.grey, thickness: 2)),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          sliver: SliverToBoxAdapter(
            child: RaisedButton(
              onPressed: () {
                if (_date != '----' &&
                    _from != '--' &&
                    _until != '--' &&
                    _people > 0) {
                  _makeReservationBloc.add(SubmittedNotMenu(
                      date: _date,
                      from: _from,
                      until: _until,
                      people: _people,
                      restaurant: _restaurant,
                      user: _user));
                }
              },
              color: brandColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text('Reservar sin menú', style: normalButton),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: Text(
                'Menú',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        (_restaurant.menu['Platos'] != null)
            ? showMenuItems(context, _restaurant.menu['Platos'], 'Platos')
            : SliverToBoxAdapter(child: Container()),
        (_restaurant.menu['Bebidas'] != null)
            ? showMenuItems(context, _restaurant.menu['Bebidas'], 'Bebidas')
            : SliverToBoxAdapter(child: Container()),
        (_restaurant.menu['Otros'] != null)
            ? showMenuItems(context, _restaurant.menu['Otros'], 'Otros')
            : SliverToBoxAdapter(child: Container()),
      ],
    );
  }

  Widget showMenuItems(
      BuildContext context, Map<String, dynamic> items, String title) {
    Icon iconType;
    if (title == 'Platos') {
      iconType = Icon(Icons.local_dining);
    } else if (title == 'Bebidas') {
      iconType = Icon(Icons.local_cafe);
    } else {
      iconType = Icon(Icons.fastfood);
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  iconType,
                ],
              ),
            ),
            Container(
              height: 150,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  String item = items.keys.elementAt(index);
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
                          item,
                          style: cardTitleStyle,
                        ),
                        subtitle: Text(
                          'Precio: \$ ${items[item]}',
                          style: cardSubtytleStyle,
                        ),
                        onTap: () {
                          _showQuantityDialog(
                              {'item': item, 'price': items[item]});
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showOrderDetails(
      BuildContext context, List<Map<String, dynamic>> order, double total) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Precio total: \$', style: subTitle2),
              Text(total.toString(), style: subTitle2)
            ],
          ),
        ),
        Container(
          height: 150,
          child: ListView.builder(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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
        ),
        Divider(color: Colors.grey, thickness: 2),
      ],
    );
  }

  Future _showQuantityDialog(Map<String, dynamic> item) {
    TextEditingController quantityController = TextEditingController();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: quantityController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.local_dining),
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter quantity';
                      }
                      return null;
                    },
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  if (quantityController.text != '') {
                    item.addAll({'quantity': toInt(quantityController.text)});
                    _makeReservationBloc.add(Update(item: item));
                    Navigator.pop(context);
                  }
                },
                child: Text('Agregar'),
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
            title: Center(child: Text('¡Reserva exitosa!')),
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
    _makeReservationBloc.close();
    super.dispose();
  }
}
