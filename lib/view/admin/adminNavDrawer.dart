import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class adminNavDrawer extends StatefulWidget {
  const adminNavDrawer({Key key}) : super(key: key);

  @override
  _adminNavDrawerState createState() => _adminNavDrawerState();
}

class _adminNavDrawerState extends State<adminNavDrawer> {

  int selectedPage = 0;

  void selectPage(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Admin',
                    style: TextStyle(
                        fontSize: 30
                    ),
                  ),
                  Icon(
                    Icons.admin_panel_settings_sharp,
                    size: 40,
                  )
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('User Lists'),
            selected: selectedPage == 0,
            onTap: (){
              HapticFeedback.lightImpact();
              selectPage(0);
            },
          ),
        ],
      ),
    );
  }
}
