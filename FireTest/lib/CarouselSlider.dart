// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_carousel_slider/carousel_slider.dart';
//
// class CarouselSlider extends StatefulWidget {
//   @override
//   _CarouselSliderState createState() => _CarouselSliderState();
// }
//
// class _CarouselSliderState extends State<CarouselSlider> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Carousel Slider'),
//       ),
//       body: FutureBuilder(
//         future: getImage(),
//         builder: (context, snapShot) {
//           return
//         },
//       ),
//     );
//   }
//
//   Future getImage() async {
//     var firestore = Firestore.instance;
//     QuerySnapshot snapshot =
//         await firestore.collection('slider').getDocuments();
//     return snapshot.documents;
//   }
// }
