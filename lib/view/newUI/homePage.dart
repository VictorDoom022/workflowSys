import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workflow_sys/view/user/chats/UserChatList.dart';
import 'package:workflow_sys/view/user/profile/userProfile.dart';
import 'package:workflow_sys/view/user/todos/todoHome.dart';
import 'package:workflow_sys/view/user/userGroup.dart';
import 'package:workflow_sys/view/user/userHome.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int selectedIndex = 0;

  List<Widget> pageList = <Widget>[
    userHome(),
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
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home),
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
                      icon: Icon(Icons.people_sharp),
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
                      icon: Icon(Icons.account_circle_rounded),
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
