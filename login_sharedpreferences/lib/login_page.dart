import 'package:flutter/material.dart';
import 'package:login_register/credential.dart';
import 'package:login_register/main.dart';
import 'package:login_register/sharedPref.dart';

class Ground extends StatefulWidget {
  @override
  _GroundState createState() => _GroundState();
}

class _GroundState extends State<Ground> {
  Credential userLoad = Credential();
  SharedPref sharedPref = SharedPref();

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
  }

  loadSharedPrefs() async {
    try {
      Credential user = Credential.fromJson(await sharedPref.read("user"));
      setState(() {
        userLoad = user;
      });
    } catch (Excepetion) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: new Text("Nothing found!"),
          duration: const Duration(milliseconds: 500)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
              SizedBox(height: 50,),
            Text(
              "User Name: ${userLoad.username}",
              style: TextStyle(
                fontSize: 20,
                color: Colors.deepOrange
              ),
            ),
            Text(
                "Token: ${userLoad.token}"
            ),
            RaisedButton(
              color: Colors.greenAccent,
              onPressed: () {
                sharedPref.remove("user");
                userLoad = Credential();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainPage()), (Route<dynamic> route) => false);
              },
              child: Text('Logout', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}



