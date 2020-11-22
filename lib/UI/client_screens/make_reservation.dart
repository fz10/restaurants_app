import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:restaurants_app/blocs/make_reservation/bloc/make_reservation_bloc.dart';
import 'package:restaurants_app/models/models.dart';
import 'package:restaurants_app/repositories/user_repository.dart';
import 'package:restaurants_app/resources/style.dart';

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
    print(_restaurant);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Personalizar reserva'),
        centerTitle: true,
        backgroundColor: brandColor,
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.check, color: Colors.white, size: 30),
        label: Text('Reservar',
            style: TextStyle(color: Colors.white, fontSize: 15)),
        onPressed: () {},
      ),
      body: BlocProvider(
        create: (context) => _makeReservationBloc,
        child: BlocListener(
          cubit: _makeReservationBloc,
          listener: (context, state) {},
          child: BlocBuilder(
              cubit: _makeReservationBloc,
              builder: (BuildContext context, MakeReservationState state) {
                if (state is MakeReservationInitial) {
                  return showScreenContent(context);
                } else if (state is Updated) {
                  return Column(
                    children: [
                      showOrderDetails(context),
                      Expanded(child: showScreenContent(context)),
                    ],
                  );
                } else {
                  return showScreenContent(context);
                }
              }),
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
                      _people > 0 ? _people -= 1 : null;
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
                          'Precio: \$ ${items[item].toString()}',
                          style: cardSubtytleStyle,
                        ),
                        onTap: () {},
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

  Widget showOrderDetails(BuildContext context) {
    return Container();
  }

  @override
  void dispose() {
    _makeReservationBloc.close();
    super.dispose();
  }
}
