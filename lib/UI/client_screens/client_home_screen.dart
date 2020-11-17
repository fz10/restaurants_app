import 'package:flutter/material.dart';
import 'package:restaurants_app/models/client.dart';
import 'package:restaurants_app/repositories/user_repository.dart';
import 'package:restaurants_app/resources/style.dart';

import 'client_profile.dart';
import 'client_search_screen.dart';

class ClientHomeScreen extends StatefulWidget {
  final UserRepository _userRepository;
  final Client _user;

  const ClientHomeScreen({Key key, @required userRepository, Client user})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _user = user,
        super(key: key);

  @override
  _ClientHomeScreenState createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  UserRepository get _userRepository => widget._userRepository;
  Client get _user => widget._user;

  List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      SearchScreen(
          userRepository: _userRepository,
          user: _user,
          key: PageStorageKey('searchScreen')),
      Scaffold(),
      ClientProfile(),
    ];
  }

  final Map<String, IconData> _icons = const {
    'Búsqueda': Icons.search,
    'Reservas': Icons.book,
    'Perfil': Icons.person,
  };

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: _icons
            .map(
              (title, icon) => MapEntry(
                title,
                BottomNavigationBarItem(
                  icon: Icon(icon, size: 30.0),
                  title: Text(title),
                ),
              ),
            )
            .values
            .toList(),
        currentIndex: _currentIndex,
        selectedItemColor: brandColor,
        selectedFontSize: 15.0,
        unselectedItemColor: Colors.grey,
        unselectedFontSize: 13.0,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
