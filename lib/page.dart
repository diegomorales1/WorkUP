import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logincloud/DataBase/Authservice.dart';
import 'package:logincloud/DataBase/User.dart';
import 'package:logincloud/MainPageGobrr/addpyme.dart';
import 'package:logincloud/MainPageGobrr/mapa.dart';
import 'package:logincloud/MainPageGobrr/pymes.dart';
import 'package:logincloud/MainPageGobrr/Modperfil.dart';
import 'package:logincloud/loginemail.dart';
import 'package:logincloud/DataBase/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _selectDrawerItem = 3;
  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return Pymes();
      case 1:
        return Mapa();
      case 2:
        return ModPerfil();
      case 3:
        return AddPyme();
      case 4:
        return LoginPage(); //Arreglar Logout, no estoy dejando sesion en ningun momento, debo dejar sesion y retornar la login page
    }
  }

  _onSelectItem(int pos) {
    Navigator.of(context).pop();
    setState(() {
      _selectDrawerItem = pos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text("Navegacion"),
        backgroundColor: Color(0xff900c3f),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Work Up'),
              accountEmail: Text("workupstore@gmail.com"),
              decoration: BoxDecoration(color: Color(0xff900c3f)),
              currentAccountPicture: CircleAvatar(
                radius: 80.0,
                backgroundImage: ExactAssetImage('assets/images/logo.png'),
              ),
            ),
            ListTile(
                title: Text("Tus Pymes"),
                leading: Icon(Icons.storefront),
                selected: (0 == _selectDrawerItem),
                onTap: () {
                  _onSelectItem(0);
                }),
            ListTile(
              title: Text("Mapa"),
              leading: Icon(Icons.map),
              selected: (1 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(1);
              },
            ),
            ListTile(
                title: Text("Agrega tu pyme!"),
                leading: Icon(Icons.store_mall_directory_sharp),
                selected: (3 == _selectDrawerItem),
                onTap: () {
                  _onSelectItem(3);
                }),
            Divider(),
            ListTile(
              title: Text("Perfil"),
              leading: Icon(Icons.account_circle),
              selected: (2 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(
                    2); //Esto hay que modificarlo --> Crear archivo para perfil de usuarios
              },
            ),
            ListTile(
              title: Text("Salir"),
              leading: Icon(Icons.exit_to_app),
              selected: (4 == _selectDrawerItem),
              onTap: () => _onSelectItem(4),
            ),
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectDrawerItem),
    );
  }
}
