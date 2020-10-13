import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:login_register/credential.dart';
import 'package:login_register/sharedPref.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Auth System",
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  //SharedPreferences sharedPreferences;
  SharedPref sharedPref = SharedPref();
  Credential userSave = Credential();
  bool _isLoading = false;
  var errorMsg;
  final TextEditingController mobileController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          children: <Widget>[
            TextFormField(
              controller: mobileController,
              decoration: InputDecoration(
                hintText: "Phone No",
              ),
            ),
            SizedBox(height: 30.0),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
              ),
            ),
            FlatButton(
              onPressed: () {
                print("Login pressed");
                setState(() {
                  _isLoading = true;
                });
                signIn(mobileController.text, passwordController.text);
              },
              color: Colors.deepOrangeAccent,
              child: Text("Sign In", style: TextStyle(color: Colors.black)),
            ),
            errorMsg == null? Container(): Text(
              "${errorMsg}",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  signIn(String mobile, pass) async {
    //SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'mobile': mobile,
      'password': pass
    };
    var jsonResponse = null;
    var response = await http.post("http://medimate.skoder.tech/api/user-login", body: data);
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if(jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        //sharedPreferences.setString("token", jsonResponse['data']['token']);
        userSave.token = jsonResponse['data']['token'];
        userSave.username = jsonResponse['data']['user']['name'];
        sharedPref.save("user", userSave);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Ground()), (Route<dynamic> route) => false);
      }
    }
    else {
      setState(() {
        _isLoading = false;
      });
      errorMsg = response.body;
      print("The error message is: ${response.body}");
    }
  }
}



