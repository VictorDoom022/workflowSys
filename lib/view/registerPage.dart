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
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Register'),
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Register',
                  style: TextStyle(
                      fontSize: 50
                  ),
                ),
                CupertinoTextField(
                  placeholder: 'Name',
                  controller: nameController,
                ),
                SizedBox(height: 10),
                CupertinoTextField(
                  placeholder: 'Email',
                  controller: emailController,
                ),
                SizedBox(height: 10),
                CupertinoTextField(
                  placeholder: 'Password',
                  controller: passwordController,
                  obscureText: true,
                ),
                SizedBox(height: 10),
                CupertinoTextField(
                  placeholder: 'Confirm Password',
                  controller: passwordConfirmController,
                  obscureText: true,
                ),
                SizedBox(height: 10),
                CupertinoButton(
                  onPressed: () async{
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
                  color: Colors.blue,
                  child: Text('Register'),
                ),
                SizedBox(height: 20),
                CupertinoButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Login'),
                      ],
                    ),
                    onPressed: (){
                      Navigator.pop(
                          context,
                          CupertinoPageRoute(
                              builder: (context){
                                return loginPage();
                              }
                          )
                      );
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
