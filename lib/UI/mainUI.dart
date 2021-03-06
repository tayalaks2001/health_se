import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:health_se/main.dart' as Main;
import 'package:health_se/UI/HealthProfileUI.dart';
import 'package:health_se/UI/UserProfileUI.dart';
import 'package:health_se/UI/DailyDietUI.dart';
import 'package:health_se/UI/InputLocationUI.dart';

class MyApp extends StatefulWidget {
  MyApp({Key key, @required this.tab}) : super(key: key);
  final tab;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserProfileUI user_profile;
  // InfectiousUI infectious_page;
  DailyDietUI daily_diet;
  HealthProfileUI health_profile;
  InputLocationUI infectious_page;

  List<Widget> pages;
  List<String> titles;
  Widget currentPage;
  int currentTab = 0;

  @override
  void initState() {
    user_profile = UserProfileUI();
    health_profile = HealthProfileUI();
    infectious_page = InputLocationUI();
    daily_diet = DailyDietUI();

    pages = [health_profile, daily_diet, infectious_page, user_profile];
    titles = [
      'Health Profile',
      'Daily Diet',
      'Input user location',
      'User Profile'
    ];

    currentTab = widget.tab;
    currentPage = pages[currentTab];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xFF479055),
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text(titles[currentTab]),
            leading: FlatButton.icon(
              onPressed: () {
                setState(() {
                  currentTab = 0;
                  currentPage = health_profile;
                });
              },
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                size: 20,
              ),
              label: Text(""),
              textColor: Colors.white,
            ),
            centerTitle: true,
            actions: <Widget>[
              PopupMenuButton(
                  itemBuilder: (BuildContext bc) => [
                        PopupMenuItem(
                            child: Text("Change password"), value: "/cp"),
                        PopupMenuItem(
                            child: Text("Notification management"),
                            value: "/notif"),
                        PopupMenuItem(
                            child: Text("Log Out"), value: "/log-out"),
                      ],
                  onSelected: (String route) {
                    if (route == "/cp") {}
                    if (route == "/notif") {}
                    if (route == "/log-out") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Main.MyApp()));
                    }
                  })
            ],
          ),
          body: currentPage,
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentTab,
            onTap: (int index) {
              setState(() {
                currentTab = index;
                currentPage = pages[index];
              });
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.accessibility),
                label: "Health profile",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_menu_rounded),
                label: "Daily diet",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.coronavirus_outlined),
                label: "Infectious",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_box_rounded),
                label: "User Profile",
              ),
            ],
          ),
        ));
  }
}
