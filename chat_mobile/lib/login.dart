import 'package:flutter/material.dart';
import 'package:chat_api_client/chat_api_client.dart';
import 'globals.dart' as globals;
import 'api_client.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginData {
  String login = '';
  String password = '';
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _LoginData _loginData = new _LoginData();

  String _validateLogin(String value) {
    if (value.length < 5) {
      // check login rules here
      return 'The Login must be at least 5 characters.';
    }
    return null;
  }

  String _validatePassword(String value) {
    if (value.length < 5) {
      // check password rules here
      return 'The Password must be at least 8 characters.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Builder(
          builder: (BuildContext scaffoldContext) {
            return Container(
              padding: new EdgeInsets.all(20.0),
              child: Center(
                child: Form(
                  key: this._formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        validator: this._validateLogin,
                        onSaved: (String value) {
                          this._loginData.login = value;
                        },
                        decoration: InputDecoration(
                            hintText: 'Login', labelText: 'Enter your login'),
                      ),
                      TextFormField(
                        obscureText: true, // Use secure text for passwords.
                        validator: this._validatePassword,
                        onSaved: (String value) {
                          this._loginData.password = value;
                        },
                        decoration: new InputDecoration(
                            hintText: 'Password',
                            labelText: 'Enter your password'),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(
                                child: Text("Login"),
                                onPressed: () {
                                  _login(scaffoldContext);
                                }),
                            FlatButton(
                              child: Text("Sign In"),
                              onPressed: () {
                                //  TODO: implement this
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  _login(BuildContext context) async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        UsersClient usersClient = UsersClient(MobileApiClient());
        var user =
            await usersClient.login(_loginData.login, _loginData.password);
        globals.currentUser = user;
            Navigator.pushNamed(context, '/chat_list');
      } on Exception catch (e) {
        final snackBar = SnackBar(content: Text('Login failed'));
        Scaffold.of(context).showSnackBar(snackBar);
        print('Login failed');
        print(e);
      }
    }
  }
}
