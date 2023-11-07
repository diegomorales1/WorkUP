import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logincloud/DataBase/cosasDeperfil/profileNotifier.dart';


class Usuario {
  final String uid;

  Usuario({this.uid});

}

class UserData {
  String email;
  String name;
  String media;


  UserData(
      {this.email,
      this.name,
      this.media,});

  UserData.fromMap(Map<String, dynamic> data) {
    email = data['email'];
    name = data['name'];
  }
  
  getUserData(ProfileNotifier profileNotifier) async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("users").get();
    List<UserData> _profileList = [];
    snapshot.docs.forEach((doc) {
      UserData data = UserData.fromMap(doc.data()); //aqui el doc.data iba así, pero con los parentesis no tira error
      _profileList.add(data);
    });

    profileNotifier.profileList = _profileList;
  }
}
