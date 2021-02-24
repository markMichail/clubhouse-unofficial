import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = '/extractArguments';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool("show_warning_message") == null) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Alert!"),
              content: Text(
                  "This is unofficial app and the probability of getting your Clubhouse account banned is not zero."),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    prefs.setBool("show_warning_message", true);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: ListView(
          children: [
            Text(
              " 🎉 Welcome!",
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: Colors.black),
            ),
            SizedBox(height: 20.0),
            Text(
              "We're working hard to get Clubhouse ready for launch! While we wrap up the finishing touches, we're adding people gradually to make sure nothing breaks. :)",
              style:
                  Theme.of(context).textTheme.headline6.copyWith(height: 2.0),
            ),
            SizedBox(height: 25.0),
            Text(
              "If you don't yet have an invite, you can reserve your username now and we'll get you on very soon. We are so grateful you're here and can't wait to have you join! 🙏🏽",
              style:
                  Theme.of(context).textTheme.headline6.copyWith(height: 2.0),
            ),
            SizedBox(height: 25.0),
            Text(
              "🏠 Paul, Rohan & the Clubhouse team",
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 25.0),
            MaterialButton(
              onPressed: () {},
              child: Text(
                "Get your username (Not working)",
                style: TextStyle(color: Colors.white),
              ),
              color: Color.fromRGBO(84, 118, 170, 1),
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              height: 50,
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Have an invited text? ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Color.fromRGBO(84, 118, 170, 1)),
                ),
                InkWell(
                  onTap: () {},
                  child: Text(
                    "Sign in",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Color.fromRGBO(84, 118, 170, 1)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
