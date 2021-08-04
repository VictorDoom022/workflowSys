import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workflow_sys/controller/authController.dart';

import 'loginPage.dart';
import 'misc/loadingScreen.dart';

class registerPage extends StatefulWidget {
  const registerPage({Key key}) : super(key: key);

  @override
  _registerPageState createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {

  final GlobalKey registerPageGlobalKey = new GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .1),
                    registerTitle(),
                    SizedBox(height: 50),
                    Column(
                      children: [
                        nameField(),
                        emailField(),
                        passwordField(),
                        confirmPasswordField(),
                      ],
                    ),
                    SizedBox(height: 20),
                    registerButton(),
                    SizedBox(height: 20),
                    divider(),
                    SizedBox(height: 20),
                    loginButton(),
                  ],
                ),
              ),
            ),
            Positioned(top: 5, left: 0, child:   backButton()),
          ],
        ),
      ),
    );
  }

  Widget registerTitle() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Register',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
      ),
    );
  }

  Widget nameField(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Name',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true
            ),
          ),
        ],
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
            ),
          ),
        ],
      ),
    );
  }

  Widget confirmPasswordField(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Confirm Password',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            obscureText: true,
            controller: passwordConfirmController,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true
            ),
          ),
        ],
      ),
    );
  }

  Widget registerButton() {
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
            )
        ),
        child: Text(
          'Register',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        if(emailController.text.isEmpty == true){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email cannot be empty.')));
        }else if(nameController.text.isEmpty == true){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Name cannot be empty.')));
        }else if(passwordController.text.isEmpty == true || passwordConfirmController.text.isEmpty == true){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password cannot be empty')));
        }else if(passwordController.text != passwordConfirmController.text){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password not identical')));
        }else if(passwordController.text.length < 8){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password must have minimum of 8 characters')));
        }else{
          LoadingScreen.showLoadingScreen(context, registerPageGlobalKey);
          register(context, nameController.text, emailController.text, passwordController.text, passwordConfirmController.text);
        }
      },
    );
  }

  Widget divider() {
    return Container(
      //margin: EdgeInsets.symmetric(vertical: 10),
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

  Widget loginButton() {
    return InkWell(
      onTap: (){
        Navigator.pop(
          context,
          CupertinoPageRoute(
          builder: (context){
            return loginPage();
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
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                color: Color(0xfff79c4f),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }
}
