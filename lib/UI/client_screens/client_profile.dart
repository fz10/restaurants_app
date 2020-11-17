import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurants_app/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:restaurants_app/resources/style.dart';

class ClientProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: brandColor,
              size: 30,
            ),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(
                LoggedOut(),
              );
            },
          ),
          Text(
            'Salir',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
