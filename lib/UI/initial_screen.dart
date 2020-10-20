import 'package:flutter/material.dart';
import 'package:restaurants_app/UI/login/login_screen.dart';
import 'package:restaurants_app/repositories/user_repository.dart';
import 'package:restaurants_app/resources/style.dart';

class InitialScreen extends StatelessWidget {
  final UserRepository _userRepository;

  InitialScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          getBackgroundImage(),
          getImageAsset(),
          Positioned(
            top: 360,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                clientButton(context),
                SizedBox(height: 20),
                restButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('assets/logo.png');
    Image image = Image(
      image: assetImage,
      width: 200.0,
      height: 200.0,
    );
    return Positioned(
      top: 100,
      child: image,
    );
  }

  Widget getBackgroundImage() {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/InitBackgroundImage.jpg'),
            fit: BoxFit.cover),
      ),
    );
  }

  Widget clientButton(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 50,
      child: RaisedButton(
        elevation: 3,
        color: brandColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 30.0,
            ),
            SizedBox(width: 10),
            Text(
              'Cliente',
              style: buttonTitle,
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LoginScreen(role: 'client', userRepository: _userRepository);
          }));
        },
      ),
    );
  }

  Widget restButton(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 50,
      child: RaisedButton(
        elevation: 3,
        color: brandColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant,
              color: Colors.white,
              size: 30.0,
            ),
            SizedBox(width: 10),
            Text(
              'Restaurante',
              style: buttonTitle,
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LoginScreen(role: 'admin',userRepository: _userRepository);
          }));
        },
      ),
    );
  }
}
