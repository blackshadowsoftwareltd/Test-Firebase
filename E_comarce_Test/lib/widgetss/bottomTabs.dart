import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottomTabs extends StatefulWidget {
  final int selectedtab;
  final Function(int) tabClicked;

  BottomTabs({this.selectedtab, this.tabClicked});

  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    _selectedTab = widget.selectedtab ?? 0;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), topLeft: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomTabButton(
            imgPath: Icon(
              Icons.home_rounded,
              size: 30,
            ),
            selected: _selectedTab == 0 ? true : false,
            onPressed: () {
              widget.tabClicked(0);
            },
          ),
          BottomTabButton(
            imgPath: Icon(
              Icons.search,
              size: 30,
            ),
            selected: _selectedTab == 1 ? true : false,
            onPressed: () {
              widget.tabClicked(1);
            },
          ),
          BottomTabButton(
            imgPath: Icon(
              Icons.bookmarks_outlined,
              size: 30,
            ),
            selected: _selectedTab == 2 ? true : false,
            onPressed: () {
              widget.tabClicked(2);
            },
          ),
          BottomTabButton(
            imgPath: Icon(
              Icons.logout,
              size: 30,
            ),
            selected: _selectedTab == 3 ? true : false,
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
    );
  }
}

class BottomTabButton extends StatelessWidget {
  final Widget imgPath;
  final bool selected;
  final Function onPressed;

  BottomTabButton({this.imgPath, this.selected, this.onPressed});

  @override
  Widget build(BuildContext context) {
    bool _selected = selected ?? false;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                  width: 2,
                  color: _selected
                      ? Theme.of(context).accentColor
                      : Colors.transparent),
            ),
          ),
          // margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(15),
          child: imgPath),
    );
  }
}
