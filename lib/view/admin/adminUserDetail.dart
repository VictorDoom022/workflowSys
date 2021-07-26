import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_sys/model/User.dart';
import 'package:workflow_sys/model/UserDetail.dart';
import 'package:workflow_sys/model/UserReceiver.dart';

class adminUserDetail extends StatefulWidget {

  final User user;
  final UserDetail userDetail;

  const adminUserDetail({Key key, this.user, this.userDetail}) : super(key: key);

  @override
  _adminUserDetailState createState() => _adminUserDetailState(user, userDetail);
}

class _adminUserDetailState extends State<adminUserDetail> {

  final User user;
  final UserDetail userDetail;

  _adminUserDetailState(this.user, this.userDetail);

  TextStyle textTitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold
  );

  TextStyle textInfoStyle = TextStyle(
      fontSize: 20,
      fontStyle: FontStyle.italic
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('User Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text(
                        'Account ID: ',
                        style: textTitleStyle,
                      ),
                      Text(
                        user.id.toString(),
                        style: textInfoStyle,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Name: ',
                        style: textTitleStyle,
                      ),
                      Text(
                        user.name,
                        style: textInfoStyle,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text(
                        'Email: ',
                        style: textTitleStyle,
                      ),
                      Text(
                        user.email,
                        style: textInfoStyle,
                      )
                    ],
                  ),
                  Container(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text(
                        'Create at : ',
                        style: textTitleStyle,
                      ),
                      Text(
                        user.createdAt,
                        style: textInfoStyle,
                      )
                    ],
                  ),
                  Container(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text(
                        'Account type : ',
                        style: textTitleStyle,
                      ),
                      Text(
                        user.position,
                        style: textInfoStyle,
                      )
                    ],
                  ),
                  Container(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text(
                        'Account Status: ',
                        style: textTitleStyle,
                      ),
                      Text(
                        userDetail.userDetailStatus,
                        style: textInfoStyle,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Enabled: ',
                        style: textTitleStyle,
                      ),
                      Text(
                        userDetail.userDetailAccEnable==1 ? 'yes' : 'false',
                        style: textInfoStyle,
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
