import 'package:flutter/material.dart';
import 'package:telegramchatapp/DBFirebase/Authentication.dart';
import 'package:telegramchatapp/DBFirebase/db_Firebase.dart';
import 'package:telegramchatapp/Models/user.dart';
import 'package:telegramchatapp/Pages/LoginPage.dart';
import 'package:telegramchatapp/Widgets/ProgressWidget.dart';
import 'package:telegramchatapp/Widgets/UserItemPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TUser> _userList;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    DBFirebaseHelper.getAllUsers().then((userlist) {
      setState(() {
        _userList = userlist;
        isLoading = false;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-Pigeon',style: TextStyle(color: Colors.white,fontFamily: "Signatra",fontSize: 30),),
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new,color: Colors.white,),
            onPressed: (){
              setState(() {
                isLoading = true;
              });
              AuthenticationService.logOut().then((_) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
              });
            },
          )
        ],
      ),
      body: isLoading ?  SpinKitProgress() : FutureBuilder(
        future: DBFirebaseHelper.getAllUsers(),
        builder: (context, AsyncSnapshot<List<TUser>> snapshot){
          if(snapshot.hasData){
            return ListView.builder(itemBuilder: (context,index) => UserItem(snapshot.data[index]),
              itemCount: snapshot.data.length,
            );
          }
          if(snapshot.hasError){
            return Center(child: Text('Faild To fetch Data'),);
          }
          return SpinKitProgress();
        },
      )
    );
  }
}
