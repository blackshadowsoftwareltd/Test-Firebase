import 'package:flutter/material.dart';

class ImageSwipe extends StatefulWidget {
  final List imageList;

  ImageSwipe({this.imageList});

  @override
  _ImageSwipeState createState() => _ImageSwipeState();
}

class _ImageSwipeState extends State<ImageSwipe> {
  int _selectedpage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Stack(
        children: [
          PageView(
              onPageChanged: (number) {
                setState(() {
                  _selectedpage = number;
                });
              },
              children: [
                for (var i = 0; i < widget.imageList.length; i++)
                  Container(
                      child: Image.network(
                    '${widget.imageList[i]}',
                    fit: BoxFit.cover,
                  ))
              ]),
          Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < widget.imageList.length; i++)
                    AnimatedContainer(
                        height: 10,
                        width: _selectedpage != i ? 10 : 20,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),))
                ],
              ))
        ],
      ),
    );
  }
}
