import 'package:flutter/material.dart';

class FirstBanner extends StatefulWidget {
  @override
  _FirstBannerState createState() => _FirstBannerState();
}

class _FirstBannerState extends State<FirstBanner> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      color: Colors.blueGrey,
      child: Stack(
        children: [
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/e-commerce-2a07e.appspot.com/o/banner%2Fbanner1.jpg?alt=media&token=4c03389a-9f5f-4189-aadf-184e7b454a3d',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.black.withOpacity(0.3),
            ),
            // color: Colors.black.withOpacity(0.3),
            child: Text(
              'Current Offer',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
            ),
          )
        ],
      ),
    );
  }
}
