import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_sys/controller/userController.dart';
import 'package:workflow_sys/model/User.dart';

class adminHome extends StatefulWidget {
  const adminHome({Key key}) : super(key: key);

  @override
  _adminHomeState createState() => _adminHomeState();
}

class _adminHomeState extends State<adminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Home'),
      ),
      body: StreamBuilder<Object>(
        initialData: getAllUser(),
        builder: (context, snapshot){
          return FutureBuilder<List<User>>(
            future: getAllUser(),
            builder: (context, snapshot){
              if(snapshot.hasError) print(snapshot.error);

              if(snapshot.hasData){
                return userItem(users: snapshot.data);
              }else{
                return Center(child: CupertinoActivityIndicator(radius: 12));
              }
            },
          );
        },
      ),
    );
  }
}

class userItem extends StatelessWidget {

  final List<User> users;

  const userItem({Key key, this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: users.length,
        itemBuilder: (context, index){
          return ListTile(
            title: Text(users[index].name),
            subtitle: Text(users[index].email),
          );
        }
    );
  }
}

