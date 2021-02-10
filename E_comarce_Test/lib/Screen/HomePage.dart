import 'package:E_comarce_Test/constants.dart';
import 'package:E_comarce_Test/tabs/homeTab.dart';
import 'package:E_comarce_Test/tabs/saveTab.dart';
import 'package:E_comarce_Test/tabs/searchTab.dart';
import 'package:E_comarce_Test/widgetss/bottomTabs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _tabPageController;
  int _currentTab = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabPageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabPageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('homepage');

    return Scaffold(
      // appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: PageView(
              controller: _tabPageController,
              onPageChanged: (num) {
                setState(() {
                  _currentTab = num;
                });
              },
              children: [
                HomeTab(),
                SearchTab(),
                SaveTab(),
              ],
            ),
          ),
          BottomTabs(
            selectedtab: _currentTab,
            tabClicked: (num) {
              _tabPageController.animateToPage(num,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic);
            },
          )
        ],
      ),
    );
  }
}
