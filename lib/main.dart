import 'package:club_house_unofficial/api/sharedPrefsController.dart';
import 'package:club_house_unofficial/screens/confirm_code_screen.dart';
import 'package:club_house_unofficial/screens/home_screen.dart';
import 'package:club_house_unofficial/screens/login_screen.dart';
import 'package:club_house_unofficial/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Club House - unofficial',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: SharedPrefsController.load(),
        builder: (context, prefs) {
          if (prefs.connectionState == ConnectionState.done) {
            if (SharedPrefsController.user?.userId != null) {
              // Provider.of<User>(context).setProvider(prefs.data);
              return ChangeNotifierProvider.value(
                value: SharedPrefsController.user,
                child: HomeScreen(),
              );
            } else
              return WelcomeScreen();
          }
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      ),
      routes: {
        WelcomeScreen.routeName: (context) => WelcomeScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        ConfirmCodeScreen.routeName: (context) => ConfirmCodeScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
      },
    );
  }
}
