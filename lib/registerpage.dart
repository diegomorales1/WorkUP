import 'package:flutter/material.dart';
import 'package:logincloud/Carga/loading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logincloud/DataBase/Authservice.dart';
import 'package:logincloud/DataBase/Datos.dart';
import 'dart:io';
import 'package:logincloud/DataBase/cosasDeperfil/helper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logincloud/loginemail.dart';
import 'package:logincloud/constants.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  bool loading = false;
  var selectedGenderType, selectedBlockType, selectedcourse, home;
  File _image;
  var x;
  // Future getImage() async {
  //   var image = await picker.getImage(source: ImageSource.gallery);
  //   setState(() {
  //     _image = File(image.path);
  //   });
  // }

  List<String> _courses = <String>[
    'Computer Science',
    'Business Analytics',
    'Business',
    'Arts and Social Sciences',
    'Mechanical Engineering'
  ];
  List<String> _homeArea = <String>[
    'Woodlands',
    'Serangoon',
    'Yishun',
    'Sambawang',
    'Clementi',
    'Bishan',
    'Ang Mo Kio'
  ];

  signMeUp(BuildContext context) {
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      Helper.saveUserEmailSharedPreference(email);
      Helper.saveUserNameSharedPreference(name);
      Helper.saveUserLoggedInSharedPreference(true);

      Future uploadPic() async {
        StorageReference firebaseStorageReference =
            FirebaseStorage.instance.ref().child(_image.path);

        StorageUploadTask uploadTask = firebaseStorageReference.putFile(_image);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        x = (await taskSnapshot.ref.getDownloadURL()).toString();

        await _auth.registerWithEmailAndPassword(
          email,
          password,
          name,
          x,
          media,
        );
      }

      if (_image != null) {
        uploadPic();
        // takeImage(context);
      } else {
        _auth.registerWithEmailAndPassword(
          email,
          password,
          name,
          'https://firebasestorage.googleapis.com/v0/b/workup-19ea1.appspot.com/o/predeterminado.png?alt=media&token=f315dce8-e76d-4527-af8a-206238c266dc',
          media,
        );
      }
      Navigator.of(context).pushAndRemoveUntil(
          FadeRoute(page: LoginPage()), ModalRoute.withName('LoginPage'));
    }
  }

  pickImageFromGallery(context) async {
    Navigator.pop(context);
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  captureImageWithCamera(context) async {
    Navigator.pop(context);
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 680, maxWidth: 970);
  }

  takeImage(nContext) {
    return showDialog(
        context: nContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Nueva foto"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  "Capturar desde la camara",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () => captureImageWithCamera(nContext),
              ),
              SimpleDialogOption(
                child: Text(
                  "Seleccionar de la galeria",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () => pickImageFromGallery(nContext),
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  String email = '';
  String password = '';
  String error = '';
  String name = '';
  String media = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: AppBar(elevation: 0),
              body: Stack(children: <Widget>[
                SingleChildScrollView(
                  child: Container(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 10),
                                Row(children: <Widget>[
                                  Icon(
                                    Icons.alternate_email,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 3),
                                  Expanded(
                                    child: TextFormField(
                                        validator: (val) {
                                          return RegExp(
                                                      r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)")
                                                  .hasMatch(val)
                                              ? null
                                              : "Please provide a valid Email";
                                        },
                                        onChanged: (val) {
                                          setState(() => email = val);
                                        },
                                        style: TextStyle(color: Colors.black),
                                        decoration: new InputDecoration(
                                          labelText: 'Correo electronico',
                                        )),
                                  )
                                ]),
                                SizedBox(height: 10),
                                Row(children: <Widget>[
                                  Icon(
                                    Icons.lock,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 3),
                                  Expanded(
                                    child: TextFormField(
                                        obscureText: true,
                                        validator: (val) {
                                          return val.isEmpty || val.length <= 6
                                              ? 'Please provide a valid password'
                                              : null;
                                        },
                                        onChanged: (val) {
                                          setState(() => password = val);
                                        },
                                        style: TextStyle(color: Colors.black),
                                        decoration: new InputDecoration(
                                          labelText: 'Contraseña',
                                        )
                                        //decoration: textFieldInputDecoration(
                                        //    ' Password')),
                                        ),
                                  )
                                ]),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(width: 50),
                                    Align(
                                      alignment: Alignment.center,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 60,
                                        child: ClipOval(
                                          child: new SizedBox(
                                            width: 180,
                                            height: 180,
                                            child: (_image != null)
                                                ? Image.file(
                                                    _image,
                                                    fit: BoxFit.fill,
                                                  )
                                                : Image.asset(
                                                    'assets/images/predeterminado.png',
                                                    fit: BoxFit.fill,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 60),
                                      child: IconButton(
                                        color: Colors.black,
                                        icon: Icon(Icons.camera_alt, size: 30),
                                        onPressed: () {
                                          takeImage(context);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.face,
                                      color: Colors.black,
                                    ),
                                    SizedBox(width: 3),
                                    Expanded(
                                      child: TextFormField(
                                          validator: (val) {
                                            return val.isEmpty
                                                ? 'Por favor escribe tu nombre'
                                                : null;
                                          },
                                          onChanged: (val) {
                                            setState(() => name = val);
                                          },
                                          style: TextStyle(color: Colors.black),
                                          decoration: new InputDecoration(
                                            labelText: 'Nombre de usuario',
                                          )),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    signMeUp(context);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Color(0xFFFFC107)),
                                    child: Text('Crear cuenta',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Ya tienes cuenta? "),
                                    GestureDetector(
                                      onTap: () {
                                        widget.toggleView();
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        child: Text("Ingresar",
                                            style: TextStyle(
                                                color: Colors.redAccent,
                                                decoration:
                                                    TextDecoration.underline)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          );
  }
}

void _pushPage(BuildContext context, Widget page) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => page),
  );
}
