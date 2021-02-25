import 'dart:convert';

import 'package:club_house_unofficial/api/models/User.dart';
import 'package:club_house_unofficial/screens/confirm_code_screen.dart';
import 'package:club_house_unofficial/screens/home_screen.dart';
import 'package:club_house_unofficial/screens/login_screen.dart';
import 'package:club_house_unofficial/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: User(),
      child: MaterialApp(
        title: 'Club House - unofficial',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        // initialRoute: WelcomeScreen.routeName,
        home: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, prefs) {
            if (prefs.hasData) {
              if (prefs.data.getString('user') != null) {
                Provider.of<User>(context)
                    .setProvider(jsonDecode(prefs.data.getString('user')));
                return HomeScreen();
              } else
                return WelcomeScreen();
            }
            return CircularProgressIndicator();
          },
        ),
        routes: {
          WelcomeScreen.routeName: (context) => WelcomeScreen(),
          LoginScreen.routeName: (context) => LoginScreen(),
          ConfirmCodeScreen.routeName: (context) => ConfirmCodeScreen(),
          HomeScreen.routeName: (context) => HomeScreen(),
        },
      ),
    );
  }
}
