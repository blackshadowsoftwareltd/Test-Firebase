import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test App'),
      ),
      body: ListView(
        children: [
          Center(
            child: Container(
              height: 550,
              width: double.infinity,
              color: Colors.green,
              child: _image == null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'select an Image',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    )
                  : imageViewer(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: FloatingActionButton(
                  child: Icon(
                    Icons.image,
                    size: 30,
                  ),
                  onPressed: () {
                    galleryImage();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: FloatingActionButton(
                  child: Icon(
                    Icons.camera_alt,
                    size: 30,
                  ),
                  onPressed: () {
                    cameraImage();
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget imageViewer() {
    return ListView(
      children: [
        Center(child: Image.file(_image)),
        Center(
          child: FlatButton(
            child: Text(
              'Upload',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              uploadImage();
            },
          ),
        )
      ],
    );
  }

  File _image;

  Future cameraImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  Future galleryImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void uploadImage() {
    final StorageReference reference =
        FirebaseStorage.instance.ref().child('Image/img.jpg');
    final StorageUploadTask task = reference.putFile(_image);
  }
}
