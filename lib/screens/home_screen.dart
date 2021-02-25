import 'package:club_house_unofficial/api/models/User.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User user;
  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15, top: 10),
            child: InkWell(
              onTap: () {},
              child: CircleAvatar(
                minRadius: 20,
                backgroundImage: NetworkImage(user.photoUrl),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: Text("home screen"),
        ),
      ),
    );
  }
}
