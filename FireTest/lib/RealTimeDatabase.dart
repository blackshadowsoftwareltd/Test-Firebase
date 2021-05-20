import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RealTimeDataBase extends StatefulWidget {
  @override
  _RealTimeDataBaseState createState() => _RealTimeDataBaseState();
}

class _RealTimeDataBaseState extends State<RealTimeDataBase> {
  final referenceDatase = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    final ref = referenceDatase.reference();
    final name = 'nameTitle';
    final nameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('RealTime Database'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.green,
                child: Column(
                  children: [
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: nameController,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        child: Text(
                          'Fatch',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          ref
                              .child('OnePlus')
                              .push()
                              .child('OnePlus8T')
                              .set(nameController.text)
                              .asStream();

                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
