import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workflow_sys/controller/authController.dart';
import 'package:workflow_sys/view/registerPage.dart';

import 'misc/loadingScreen.dart';

class loginPage extends StatefulWidget {
  const loginPage({Key key}) : super(key: key);

  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {

  final GlobalKey loginPageGlobalKey = new GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          height: height,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: height * .1),
                  appTitle(),
                  SizedBox(height: 50),
                  Column(
                    children: [
                      emailField(),
                      passwordField(),
                    ],
                  ),
                  SizedBox(height: 20),
                  loginButton(),
                  SizedBox(height: 20),
                  divider(),
                  SizedBox(height: 20),
                  registerButton(),
                ],
              ),
            ),
          ),
        ),
    );
  }

  Widget appTitle() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Workflow',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Color(0xffe46b10),
        ),
        children: [
          TextSpan(
            text: 'Sys',
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
        ]
      ),
    );
  }

  Widget emailField(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'E-mail',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true
            )
          ),
        ],
      ),
    );
  }

  Widget passwordField(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Password',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            obscureText: true,
            controller: passwordController,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true
            )
          ),
        ],
      ),
    );
  }

  Widget loginButton() {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2,
              )
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xfffbb448),
                  Color(0xfff7892b)
                ]
            ),
        ),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        LoadingScreen.showLoadingScreen(context, loginPageGlobalKey);
        login(context ,emailController.text, passwordController.text);
      },
    );
  }

  Widget divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  Widget registerButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context){
                  return registerPage();
                }
            )
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
      ),
    );
  }
}
