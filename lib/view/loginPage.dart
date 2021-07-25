import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Login'),
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 50
                  ),
                ),
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
                CupertinoButton(
                  onPressed: () async{

                  },
                  color: Colors.blue,
                  child: Text('Login'),
                ),
                SizedBox(height: 20),
                CupertinoButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Register'),
                      ],
                    ),
                    onPressed: (){

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
