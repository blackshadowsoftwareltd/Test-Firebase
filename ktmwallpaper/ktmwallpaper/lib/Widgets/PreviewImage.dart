import 'package:flutter/material.dart';

class PreviewImage extends StatelessWidget {
  final String url;

  PreviewImage({this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 50),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.deepOrange,
        child:
        FadeInImage(
            image: NetworkImage(url),
            fit: BoxFit.cover,
            placeholder: AssetImage('images/loadingIconfullscreen.jpg'))
        // Image.network(url, fit: BoxFit.cover)
    );
  }
}
class DevicePreviewImage extends StatelessWidget {
  final String url;

  DevicePreviewImage({this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
        // margin: EdgeInsets.only(bottom: 50),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.deepOrange,
        child:
        FadeInImage(
            image: NetworkImage(url),
            fit: BoxFit.cover,
            placeholder: AssetImage('images/loadingIconfullscreen.jpg'))
        // Image.network(url, fit: BoxFit.cover)
    );
  }
}
