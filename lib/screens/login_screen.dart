import 'package:club_house_unofficial/api/keys.dart';
import 'package:club_house_unofficial/api/methods/StartPhoneNumberAuth.dart';
import 'package:club_house_unofficial/screen%20arguments/confirm_code_screen_arguments.dart';
import 'package:club_house_unofficial/screens/confirm_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:house_club/api/keys.dart';
// import 'package:house_club/api/methods/StartPhoneNumberAuth.dart';
// import 'package:house_club/screens/confirm_code_screen.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/loginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _enableNextButton = false;
  FocusNode _focusNode = FocusNode();
  PhoneNumber _phoneNumber;
  TextEditingController _phoneNumberTextController = TextEditingController();
  String _phoneNumberText = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String isoCode;
    try {
      isoCode = await FlutterSimCountryCode.simCountryCode;
    } on PlatformException {
      isoCode = 'US';
    }
    setState(() {
      _phoneNumber = PhoneNumber(isoCode: isoCode, phoneNumber: "");
    });
  }

  login() async {
    var phoneNumber = _phoneNumberText;
    showLoadingDialog(context);
    await StartPhoneNumberAuth(phoneNumber: phoneNumber, context: context)
        .getVerificationCode()
        .then((response) {
      Navigator.of(context).pop();
      if (response['success']) {
        Navigator.of(context).pushNamed(
          ConfirmCodeScreen.routeName,
          arguments: ConfirmCodeScreenArguments(phoneNumber: phoneNumber),
        );
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
              "Enter your phone #",
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: InternationalPhoneNumberInput(
                autoFocusSearch: true,
                countrySelectorScrollControlled: true,
                textFieldController: _phoneNumberTextController,
                initialValue: _phoneNumber,
                onInputChanged: (pn) {
                  _phoneNumberText = pn.toString();
                },
                onInputValidated: (val) {
                  if (val)
                    setState(() {
                      _enableNextButton = true;
                    });
                  else {
                    if (_enableNextButton == true) {
                      setState(() {
                        _enableNextButton = false;
                      });
                    }
                  }
                },
                spaceBetweenSelectorAndTextField: 2,
                selectorButtonOnErrorPadding: 5,
                onFieldSubmitted: (_) {
                  _focusNode.unfocus();
                },
                focusNode: _focusNode,
                formatInput: true,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                ignoreBlank: true,
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  showFlags: true,
                  useEmoji: false,
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                  "By entering your number, you're agreeing to our Terms of Service and Privacy Policy. Thanks!"),
            ),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: !_enableNextButton ? null : login,
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
