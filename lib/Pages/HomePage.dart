import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:telegramchatapp/DBFirebase/Authentication.dart';
import 'package:telegramchatapp/DBFirebase/db_Firebase.dart';
import 'package:telegramchatapp/Models/user.dart';
import 'package:telegramchatapp/Pages/AccountSettingsPage.dart';
import 'package:telegramchatapp/Pages/LoginPage.dart';
import 'package:telegramchatapp/Widgets/ProgressWidget.dart';
import 'package:telegramchatapp/Widgets/UserItemPage.dart';
import 'package:flutter_offline/flutter_offline.dart';

import 'ProfilePage.dart';

class HomePage extends StatefulWidget {

  final TUser user;
  HomePage({this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TUser user = TUser();
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
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        elevation: 0.0,
        title: Text("E-pigeon",style: TextStyle(color: Colors.white,fontFamily: "Avenir",),),
        actions: [
          IconButton(
            splashColor: Colors.white,
            icon: Icon(Icons.search,size: 30,),
            onPressed: (){
              showSearch(context: context, delegate: _UserSearchDelegete()).then((users){
                if(users != null){

                }
              });
            }
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            DrawerHeader(
              child: Container(
                  height: 142,
                  width: 142/*MediaQuery.of(context).size.width*/,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.lightBlueAccent,width: 2),
                    borderRadius: BorderRadius.circular(55),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(55),
                    child: Image.asset(
                      "assets/images/repigeon.gif",
                      fit: BoxFit.cover,
                    ),
                  )),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  //currentIndex = 3;
                });
                Navigator.of(context).pop();
              },
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
                child: Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontFamily: 'Avenir',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
              child: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontFamily: 'Avenir',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'About',
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontFamily: 'Avenir',
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: (){
                AuthenticationService.logOut().then((_){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
                });
              },
              child: Text(
                'Log Out',
                 style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontFamily: 'Avenir',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Material(
              borderRadius: BorderRadius.circular(500),
              child: InkWell(
                borderRadius: BorderRadius.circular(500),
                splashColor: Colors.black45,
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.lightBlueAccent,
                  child: Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 65,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.lightBlueAccent,
                    child: Center(
                      child: Text(
                        'v1.0.0',
                        style: TextStyle(
                          fontFamily: 'Avenir',
                          fontSize: 20,
                          color: const Color(0xffffffff),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
      body: isLoading ?  SpinKitProgress() :
          FutureBuilder(
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
          ),
      );
  }
}

class _UserSearchDelegete extends SearchDelegate<String>{
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.cancel),
        onPressed: (){
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: DBFirebaseHelper.getUserByName(query),
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
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Search Users",style: TextStyle(color: Colors.lightBlueAccent,fontSize: 30),),
      ),
    );
  }
  
}
