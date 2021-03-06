import 'package:flutter/material.dart';
import 'package:health_se/Controller/LoginController.dart';
import 'package:health_se/UI/CreateProfileUI.dart';
import 'package:health_se/UI/mainUI.dart';

class LoginUI extends StatefulWidget {
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  final username = TextEditingController();
  final password = TextEditingController();
  bool _validate = false;
  bool _validatep = false;

  getItemAndNavigate(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyApp(tab: 0)));
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = RaisedButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text(
          "Your username/password is invalid. Please re-enter your credentials!"),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void onSubmit() async {
    setState(() {
      username.text.isEmpty ? _validate = true : _validate = false;
      password.text.isEmpty ? _validatep = true : _validatep = false;
    });

    var res = await LoginController.validateLogin(username.text, password.text);
    if (res == true) {
      getItemAndNavigate(context);
    } else
      showAlertDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
            backgroundColor: Color(0xFF479055),
            body: SingleChildScrollView(
              reverse: true,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 120.0),
                  Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage('images/logo.png'),
                        height: 150.0,
                        width: 150.0,
                      ),
                      SizedBox(height: 30.0),
                      Text('MyHealth',
                          style: TextStyle(
                              fontFamily: 'FjallaOne',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: username,
                          autocorrect: true,
                          decoration: new InputDecoration(
                            errorText:
                                _validate ? 'Value Can\'t Be Empty' : null,
                            border: InputBorder.none,
                            hintText: 'Enter your username',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(25.7),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(25.7),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            controller: password,
                            obscureText: true,
                            decoration: InputDecoration(
                              errorText:
                                  _validatep ? 'Value Can\'t Be Empty' : null,
                              filled: true,
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              hintText: 'Enter your password',
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.white),
                                borderRadius: new BorderRadius.circular(25.7),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.white),
                                borderRadius: new BorderRadius.circular(25.7),
                              ),
                            )),
                      ),
                      SizedBox(height: 30.0),
                      // ignore: deprecated_member_use
                      RaisedButton(
                        onPressed: (onSubmit),
                        color: Colors.green,
                        textColor: Colors.white,
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.0),
                        ),
                      ),
                      // ignore: deprecated_member_use
                      FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateProfileUI()),
                          );
                        },
                        color: Colors.transparent,
                        textColor: Colors.white,
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text(
                          'New User? Click here to create an account',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.0),
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            )),
      ),
    );
  }
}
