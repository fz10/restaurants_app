import 'package:flutter/material.dart';
import 'package:restaurants_app/UI/client_screens/make_reservation.dart';
import 'package:restaurants_app/models/models.dart';
import 'package:restaurants_app/repositories/user_repository.dart';
import 'package:restaurants_app/resources/style.dart';

class RestaurantDetails extends StatelessWidget {
  final UserRepository _userRepository;
  final Client _user;
  final Restaurant _restaurant;

  const RestaurantDetails(
      {Key key, @required userRepository, Client user, Restaurant restaurant})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _user = user,
        _restaurant = restaurant,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Detalles del restaurante'),
        centerTitle: true,
        backgroundColor: brandColor,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white, size: 30),
          tooltip: 'Reservar',
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return MakeReservation(
                  userRepository: _userRepository,
                  user: _user,
                  restaurant: _restaurant,
                );
              },
            ));
          },
        ),
      ),
      body: _restaurantDetails(),
    );
  }

  Widget _restaurantDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Text(_restaurant.name, style: restNameStyle),
                Text(_restaurant.cuisine, style: subTitle),
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
                      Icons.phone,
                      size: 40,
                    ),
                    Text('Teléfono', style: subTitle),
                  ],
                ),
                Text(_restaurant.phone, style: subTitle2),
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
                      Icons.home,
                      size: 40,
                    ),
                    Text('Dirección', style: subTitle),
                  ],
                ),
                Text(
                  _restaurant.address,
                  style: TextStyle(fontSize: 20),
                ),
                Divider(color: Colors.grey, thickness: 2)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.access_time, size: 30),
                        Text('Abre', style: subTitle2),
                      ],
                    ),
                    Text(_restaurant.open, style: TextStyle(fontSize: 25)),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.access_time, size: 30),
                        Text('Cierra', style: subTitle2),
                      ],
                    ),
                    Text(_restaurant.close, style: TextStyle(fontSize: 25)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
