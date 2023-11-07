import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:logincloud/DataBase/User.dart';
import 'package:logincloud/DataBase/Datos.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  getUserByUsername(String name) async {
    return FirebaseFirestore.instance
        .collection('users')
        .where("name", isGreaterThanOrEqualTo: name)
        .get();
  }

  getUserByUserEmail(String email) async {
    return FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: email)
        .get();
  }

  //collection reference
  final CollectionReference wiggleCollection =
      FirebaseFirestore.instance.collection('users');
  final chatReference = FirebaseFirestore.instance.collection('ChatRoom');
  final anonChatReference = FirebaseFirestore.instance.collection('Anonymous ChatRoom');
  final cloudReference = FirebaseFirestore.instance.collection('cloud');
  final feedReference = FirebaseFirestore.instance.collection('feed');


  getForumMessages(String desc) async {
    return FirebaseFirestore.instance
        .collection("blogs")
        .doc(desc)
        .collection("blogs")
        .orderBy("time", descending: false)
        .snapshots();
  }

  uploadtoken(String fcmToken) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tokens')
        .doc(uid)
        .set({
      'token': fcmToken,
      'createdAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem
    });
  }

  Future acceptRequest(String ownerID, String ownerName, String userDp,
      String userID, String senderEmail) {
    return feedReference
        .doc(ownerID)
        .collection('feed')
        .doc(senderEmail)
        .set({
      'type': 'request',
      'ownerID': ownerID,
      'ownerName': ownerName,
      'timestamp': DateTime.now(),
      'userDp': userDp,
      'userID': userID,
      'status': 'accepted',
      'senderEmail': senderEmail
    });
  }

  getRequestStatus(String ownerID, String ownerName, String userDp,
      String userID, String senderEmail) async {
    return feedReference
        .doc(ownerID)
        .collection('feed')
        //.document(senderEmail)
        .where('senderEmail', isEqualTo: senderEmail)
        // .get();
        .where('type', isEqualTo: 'request')
        .snapshots();
  }


  Future uploadPhotos(String photo) async {
    return await wiggleCollection
        .doc(uid)
        .collection('photos')
        .doc()
        .set({'photo': photo});
  }

  Stream<QuerySnapshot> getphotos() {
    return wiggleCollection.doc(uid).collection('photos').snapshots();
  }

  Future uploadUserData(
      String email,
      String name,
      String media,) async {
    return await wiggleCollection.doc(uid).set({
      "email": email,
      "name": name,
      'id': uid,
      'media': media,
    });
  }

  Future updateUserData(
    String email,
    String name,
    String media,
  ) async {
    return await wiggleCollection.doc(uid).update({
      "email": email,
      "name": name,
      'id': uid,
      'media': media,
    });
  }

  //wiggle list from snapshot
  List<Datos> _wiggleListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Datos(
          id: doc.data()['id'] ?? '',
          email: doc.data()['email'] ?? '',
          name: doc.data()['name'] ?? '',
          media: doc.data()['media'] ?? '',);
    }).toList();
  }

  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        email: snapshot.data()['email'],
        name: snapshot.data()['name'],
        media: snapshot.data()['media'] ?? '',);   //data estaba sin parentesis antes de la actualizacion, no se si funcionará asi
  }

  //get wiggle stream
  Stream<List<Datos>> get wiggles {
    return wiggleCollection.snapshots().map(_wiggleListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return wiggleCollection
        .doc(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  getReceivertoken(String email) async {
    return Firestore.instance
        .collection('users')
        .document(uid)
        .collection('tokens')
        .getDocuments();
  }

}
