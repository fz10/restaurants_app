import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurants_app/UI/client_screens/client_screens.dart';
import 'package:restaurants_app/UI/initial_screen.dart';
import 'package:restaurants_app/UI/splash_screen.dart';
import 'UI/loading_screen.dart';
import 'UI/restaurant_screens/restaurant_screens.dart';
import 'package:restaurants_app/blocs/authentication/bloc/bloc.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:restaurants_app/repositories/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatefulWidget {
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final UserRepository _userRepository = UserRepository();
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    _authenticationBloc.add(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _authenticationBloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (BuildContext context, AuthenticationState state) {
            if (state is Loading) {
              return LoadingScreen();
            }
            if (state is Uninitialized) {
              return SplashScreen();
            }
            if (state is Unauthenticated) {
              return InitialScreen(userRepository: _userRepository);
            }
            if (state is NotMenu) {
              return RegisterMenu(
                  userRepository: _userRepository,
                  restaurant: state.restaurant);
            }
            if (state is AuthenticatedClient) {
              return ClientHomeScreen(
                  userRepository: _userRepository, user: state.user);
            }
            if (state is AuthenticatedRestaurant) {
              return RestaurantHomeScreen(
                  userRepository: _userRepository,
                  restaurant: state.restaurant);
            }
            return LoadingScreen();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _authenticationBloc.close();
    super.dispose();
  }
}
