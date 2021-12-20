import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workflow_sys/view/user/chats/UserChatList.dart';
import 'package:workflow_sys/view/user/profile/userProfile.dart';
import 'package:workflow_sys/view/user/todos/todoHome.dart';
import 'package:workflow_sys/view/user/userGroup.dart';
import 'package:workflow_sys/view/user/userDashboard.dart';

class desktopHomePage extends StatefulWidget {
  const desktopHomePage({Key? key}) : super(key: key);

  @override
  _DesktopHomePageState createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<desktopHomePage> {

  int selectedIndex = 0;

  List<Widget> pageList = <Widget>[
    userDashboard(),
    userGroup(),
    todoHome(),
    userProfile()
  ];

  void onNavItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('TaskIT'),
                IconButton(
                  icon: Icon(Icons.chat),
                  onPressed: (){
                    HapticFeedback.lightImpact();
                    Navigator.push(context, CupertinoPageRoute(
                        builder:(context){
                          return userChatList();
                        }
                      )
                    );
                  }
                )
              ],
            ),
            backgroundColor: Colors.amber,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                enableFeedback: true,
                currentIndex: selectedIndex,
                selectedItemColor: Colors.amber[800],
                onTap: onNavItemTapped,
                elevation: 2.5,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      label: '',
                      tooltip: 'Home',
                      activeIcon: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xff4A80F0).withOpacity(0.3),
                                  offset: Offset(0, 4),
                                  blurRadius: 20
                              )
                            ]
                        ),
                        child: Icon(
                          Icons.home,
                        ),
                      )
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.people_outline),
                      label: '',
                      tooltip: 'Groups',
                      activeIcon: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xff4A80F0).withOpacity(0.3),
                                  offset: Offset(0, 4),
                                  blurRadius: 20
                              )
                            ]
                        ),
                        child: Icon(
                          Icons.people_sharp,
                        ),
                      )
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.list_alt),
                      label: '',
                      tooltip: 'Todo',
                      activeIcon: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xff4A80F0).withOpacity(0.3),
                                  offset: Offset(0, 4),
                                  blurRadius: 20
                              )
                            ]
                        ),
                        child: Icon(
                          Icons.list_alt,
                        ),
                      )
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.account_circle_outlined),
                      label: '',
                      tooltip: 'Profile',
                      activeIcon: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xff4A80F0).withOpacity(0.3),
                                  offset: Offset(0, 4),
                                  blurRadius: 20
                              )
                            ]
                        ),
                        child: Icon(
                          Icons.account_circle_rounded,
                        ),
                      )
                  )
                ],
              ),
            ]),
          ),
          SliverFillRemaining(
            child: pageList.elementAt(selectedIndex),
          )
        ],
      ),
    );
  }
}