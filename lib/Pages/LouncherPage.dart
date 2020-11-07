import 'package:flutter/material.dart';
import 'package:telegramchatapp/DBFirebase/Authentication.dart';
import 'package:telegramchatapp/Pages/HomePage.dart';
import 'package:telegramchatapp/Pages/LoginPage.dart';
import 'package:telegramchatapp/Widgets/ProgressWidget.dart';

class LouncherPage extends StatefulWidget {
  @override
  _LouncherPageState createState() => _LouncherPageState();
}

class _LouncherPageState extends State<LouncherPage> {
  @override
  void initState() {
   Future.delayed(Duration.zero, (){
     AuthenticationService.getCurrentUser() == null ?
     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen())) :
     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage())
         );
   });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SpinKitProgress(),
        ],
      ),
    );
  }
}
