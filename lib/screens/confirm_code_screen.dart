import 'package:club_house_unofficial/api/keys.dart';
import 'package:club_house_unofficial/api/methods/CompletePhoneNumberAuth.dart';
import 'package:club_house_unofficial/api/models/User.dart';
import 'package:club_house_unofficial/screen%20arguments/confirm_code_screen_arguments.dart';
import 'package:club_house_unofficial/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmCodeScreen extends StatefulWidget {
  static const routeName = '/confirmCodeScreen';
  ConfirmCodeScreen();
  @override
  _ConfirmCodeScreenState createState() => _ConfirmCodeScreenState();
}

class _ConfirmCodeScreenState extends State<ConfirmCodeScreen> {
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  verifyCode(phoneNumber, context) async {
    showLoadingDialog(context);
    await CompletePhoneNumberAuth(phoneNumber: phoneNumber)
        .verifyCode(_textEditingController.text)
        .then((response) {
      Navigator.of(context).pop();
      print(response['success']);
      if (response['success']) {
        Provider.of<User>(context, listen: false)
            .setProvider(response['user_profile']);
        print(Provider.of<User>(context, listen: false).photoUrl);
        print(Provider.of<User>(context, listen: false).authToken);
        Navigator.of(context).pushNamedAndRemoveUntil(
            HomeScreen.routeName, (Route<dynamic> route) => false);
      } else {
        showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text("Error!"),
            content: new Text(response['message']),
            actions: [
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ConfirmCodeScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    // print(args.phoneNumber);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 100),
            Text(
              "Enter The code we \n just texted you",
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: TextField(
                  controller: _textEditingController,
                  onChanged: (_) {
                    setState(() {
                      _textEditingController = _textEditingController;
                    });
                  },
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                )),
            Spacer(),
            MaterialButton(
              onPressed: _textEditingController.text.length < 4
                  ? null
                  : () => verifyCode(args.phoneNumber, this.context),
              disabledColor: Color.fromRGBO(84, 118, 170, 0.5),
              child: Text(
                "Next",
                style: TextStyle(color: Colors.white),
              ),
              color: Color.fromRGBO(84, 118, 170, 1),
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              height: 50,
              minWidth: 200,
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
