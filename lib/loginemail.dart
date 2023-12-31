import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logincloud/googlepage.dart';
import 'package:logincloud/page.dart';
import 'package:logincloud/registerpage.dart';
import 'package:logincloud/DataBase/Authservice.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth',
      home: LoginPage(title: 'Firebase Auth'),
    );
  }
}

class LoginPage extends StatefulWidget {
  final String title;

  LoginPage({Key key, this.title}) : super(key: key);

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false, //evitar error bottom overflowed
      body: Form(
        key: _formKey,
        //autovalidate: _autovalidate,
        child: Container(
          //padding: EdgeInsets.all(15.0),
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage('assets/images/curved.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              //Carta principal de la app (es el cuadrado que contiene todo)
              Container(
                child: new Card(
                  color: Colors.grey[100],
                  margin: new EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 250.0, bottom: 80.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 8.0,
                  child: new Padding(
                    padding: new EdgeInsets.all(25.0),
                    child: new Column(
                      children: <Widget>[
                        new Container(
                          child: new TextFormField(
                            maxLines: 1,
                            controller: _emailController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            decoration: new InputDecoration(
                                labelText: 'Correo electronico', icon: Icon(Icons.email)),
                            onFieldSubmitted: (value) {
                              //FocusScope.of(context).requestFocus(_phoneFocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Escribe tu nombre';
                              }
                            },
                          ),
                        ),
                        new Container(
                          child: new TextFormField(
                            maxLines: 1,
                            obscureText: true,
                            controller: _passwordController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            decoration: new InputDecoration(
                              labelText: 'Contraseña',
                              icon: Icon(
                                Icons.vpn_key,
                                color: Colors.black,
                              ),
                            ),
                            onFieldSubmitted: (value) {
                              //FocusScope.of(context).requestFocus(_phoneFocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Escribe tu contraseña';
                              }
                            },
                          ),
                        ),
                        new Padding(padding: new EdgeInsets.only(top: 30.0)),
                        new RaisedButton(
                          color: Colors.blue,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          padding: new EdgeInsets.all(16.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                'Ingresar',
                                style: new TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          onPressed: () {
                              var user = _authService.signInWithEmailAndPassword(_emailController.text, _passwordController.text);
                              if ( user != null) {
                                _pushPage(context, MainPage());
                              } else {
                                print('Sesión no iniciada');
                              }
                          }
                        ),
                        Divider(),
                        new RaisedButton(
                          color: Colors.blue,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          padding: new EdgeInsets.all(16.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                'Ingresar con Google',
                                style: new TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          onPressed: () => _pushPage(context, SignInDemo()),
                        ),
                        Divider(),
                        new RaisedButton(
                          color: Colors.deepOrange[300],
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          padding: new EdgeInsets.all(10.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                'Registrate ya!',
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                              ),
                            ],
                          ),
                          onPressed: () => _pushPage(context, Register()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//  void signInWithEmail() async {
//    // marked async
//    User user;
//    try {
//      user = await _auth.signInWithEmailAndPassword(
//          email: _emailController.text, password: _passwordController.text);
//    } catch (e) {
//      print(e.toString());
//    } finally {
//      if (user != null) {
//        // sign in successful!
//        _pushPage(context, MainPage());
//      } else {
//        // sign in unsuccessful
//        print('sign in Not');
//        // ex: prompt the user to try again
//      }
//    }
//  }
}

void _pushPage(BuildContext context, Widget page) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => page),
  );
}
