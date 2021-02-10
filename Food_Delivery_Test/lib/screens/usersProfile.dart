import 'dart:io';
import 'package:Food_Delivery_Test/screens/HomePage.dart';
import 'package:Food_Delivery_Test/screens/editProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UsersProfile extends StatefulWidget {
  @override
  _UsersProfileState createState() => _UsersProfileState();
}

class _UsersProfileState extends State<UsersProfile> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final CollectionReference userdataRef =
      FirebaseFirestore.instance.collection('UsersInFo');
  String imageUrl, profileImage = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getUserProfileImage();
  }

  String userName, address, mail;
  int contactNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.green[400], title: Text('User Profile')),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(children: [
              Container(
                  height: 300,
                  // color: Colors.greenAccent,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Stack(children: [
                    Container(
                        height: 300,
                        width: 280,
                        // color: Colors.deepPurple,
                        alignment: Alignment.topCenter,
                        child: (profileImage != null)
                            ? Container(
                                height: 280,
                                width: 300,
                                // color: Colors.green,
                                // alignment: Alignment.center,
                                child: getUserProfileImage())
                            : Center(
                                child: CircleAvatar(
                                    maxRadius: 130,
                                    child: Icon(Icons.person,
                                        color: Colors.green[400], size: 60)))),
                    Positioned(
                        bottom: 0,
                        child: Container(
                            height: 70,
                            width: 280,
                            alignment: Alignment.center,
                            // color: Colors.orange,
                            child: FloatingActionButton(
                                child: Icon(Icons.add_photo_alternate_outlined,
                                    size: 30, color: Colors.white),
                                backgroundColor: Colors.green[400],
                                onPressed: () => uploadImage())))
                  ])),
              Container(
                  child: FutureBuilder(
                      future:
                          userdataRef.doc(_firebaseAuth.currentUser.uid).get(),
                      builder: (context, snapShot) {
                        if (snapShot.hasError) {
                          return Center(child: Text(snapShot.error));
                        }
                        if (snapShot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> document = snapShot.data.data();
                          userName = document['userName'] ?? '';
                          mail = document['mail'] ?? '';
                          address = document['address'] ?? '';
                          contactNumber = document['contactNumber'];
                          return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    height: 50,
                                    // color: Colors.green,
                                    alignment: Alignment.center,
                                    child: Text(userName,
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.green[800]))),
                                Container(
                                    height: 30,
                                    // color: Colors.green,
                                    alignment: Alignment.topLeft,
                                    child: Text('Email: $mail',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.green[800]))),
                                Container(
                                    height: 30,
                                    // color: Colors.green,
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        'Contact number: $contactNumber',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.green[800]))),
                                Container(
                                    // height:30,
                                    // color: Colors.green,
                                    alignment: Alignment.topLeft,
                                    child: Text('Address: $address',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.green[800]))),
                                Container(
                                    margin: EdgeInsets.all(10),
                                    alignment: Alignment.center,
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.edit_outlined,
                                          size: 30,
                                          color: Colors.green[900],
                                        ),
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditProfile(
                                                      mail: mail,
                                                      userName: userName,
                                                      contactNumber:
                                                          contactNumber,
                                                      address: address,
                                                    ))))),
                              ]);
                        }
                        return Container(
                            height: 150,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator());
                      }))
            ])));
  }

  uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    //check permission
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      print('granted.......');
      // Select Image
      image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(image.path);

      if (image != null) {
        //Upload to Firebase
        var snapShot =
            await _storage.ref().child('UserProfile/imageName').putFile(file);
        var downloadUrl = await snapShot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
          _usersProfileImage();
          print('>>>>>>>$imageUrl');
        });
      } else {
        print('Empty Path');
      }
    } else {
      print('granted failed.........');
    }
  }

  Future _usersProfileImage() async {
    print('called..........................................');

    return await FirebaseFirestore.instance
        .collection('UsersInFo')
        .doc(_firebaseAuth.currentUser.uid)
        .update({
      'profileImage': imageUrl,
    });
  }

  Widget getUserProfileImage() {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('UsersInFo')
            .doc(_firebaseAuth.currentUser.uid)
            .get(),
        builder: (context, snapShot) {
          if (snapShot.hasError) {
            return Text(snapShot.error);
          }

          if (snapShot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapShot.data.data();

            return CircleAvatar(
              maxRadius: 130,
              backgroundImage: NetworkImage(data['profileImage']),
            );
          }

          return CircularProgressIndicator();
        });
  }
}
