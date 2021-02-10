import 'package:E_comarce_Test/constants.dart';
import 'package:flutter/material.dart';

class StorageSize extends StatefulWidget {
  final List storageSize;
  final Function (String) onSelected;

  StorageSize({this.storageSize,this.onSelected});

  @override
  _StorageSizeState createState() => _StorageSizeState();
}

class _StorageSizeState extends State<StorageSize> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < widget.storageSize.length; i++)
          GestureDetector(
            onTap: () {
              widget.onSelected('${widget.storageSize[i]}');
              setState(() {
                _selected = i;
              });
            },
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
              decoration: BoxDecoration(
                  color: _selected == i
                      ? Theme.of(context).accentColor
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(50)),
              child: Text(widget.storageSize[i],
                  style: _selected == i
                      ? TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold)
                      : Constants.boldHeading),
            ),
          ),
      ],
    );
  }
}
