import 'package:flutter/material.dart';

class FullView extends StatefulWidget {
  String imgUrl;

  FullView(this.imgUrl);

  @override
  _FullViewState createState() => _FullViewState();
}

class _FullViewState extends State<FullView> {
  final LinearGradient _gradient = LinearGradient(
      colors: [Colors.blue[900], Colors.blue[400]],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: Container(
            decoration: BoxDecoration(gradient: _gradient),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Hero(
                    tag: widget.imgUrl,
                    child: Image.network(widget.imgUrl),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppBar(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        leading: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        title: Text('Wallpaper'),
                        centerTitle: true,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
