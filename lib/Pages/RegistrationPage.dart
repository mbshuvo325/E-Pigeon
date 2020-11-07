import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telegramchatapp/DBFirebase/Authentication.dart';
import 'package:telegramchatapp/DBFirebase/db_Firebase.dart';
import 'package:telegramchatapp/Models/user.dart';
import 'package:telegramchatapp/Pages/HomePage.dart';
import 'package:telegramchatapp/Widgets/ProgressWidget.dart';
import 'package:telegramchatapp/Widgets/SetProfile.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formkey = GlobalKey<FormState>();
  var user = TUser();
  bool isLoading = false;
  String email = '';
  String password = '';
  String uid;
  String _errorMsg = '';
  String _date = DateTime.now().millisecondsSinceEpoch.toString();
  String _status = 'I am avilable';

  _authenticate() async {
    if(_formkey.currentState.validate()){
      _formkey.currentState.save();
      try{
        user.createdAt = _date;
        user.aboutme = _status;
        uid = await AuthenticationService.register(email, password);
        DBFirebaseHelper.insertUser(user).then((_){
          Fluttertoast.showToast(msg: 'Registration Successfull');
        });
        if(uid != null){
          isLoading = false;

          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
        }
      }catch(error){
        setState(() {
          _errorMsg = error.message;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.width*2,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Image.asset('assets/images/pigeon.png',height: 100,width: 100,),
                  //Text('E-Pigeon',style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 52,fontFamily: "Signatra"),),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    margin: EdgeInsets.only(left: 30, top: 20, right: 30,),
                    height: 410,//double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft:  Radius.circular(10),
                        bottomRight:  Radius.circular(10),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2,left: 10,right: 10, bottom: 5),
                      child: Form(
                        key: _formkey,
                        child: Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Register',style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 30),),
                              SizedBox(height: 10,),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  labelText: "Your Name",
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return "Name Should't be empty!";
                                  }
                                },
                                onSaved: (value){
                                  user.nickname = value;
                                },
                              ),
                              SizedBox(height: 10,),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  labelText: "Enter Email Address",
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return "Email Should't be empty!";
                                  }
                                },
                                onSaved: (value){
                                  email = value;
                                },
                              ),
                              SizedBox(height: 10,),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  labelText: "Enter Password",
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return "Password Should't be empty!";
                                  }
                                },
                                onSaved: (value){
                                  password = value;
                                },
                              ),
                              SizedBox(height: 5,),
                              /*Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 2, color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: _imagePath == null
                                          ? Text('Upload an Image',textAlign: TextAlign.center,)
                                          : Image.file(File(_imagePath),fit: BoxFit.cover,),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.camera_alt,size: 40,color: Colors.lightBlueAccent,),
                                      onPressed: (){
                                        getImage();
                                      },
                                    ),
                                  ],
                                ),
                              ),*/
                              SizedBox(height: 10,),
                              Container(
                                width: double.infinity,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: Theme.of(context).primaryColor,
                                  child: Text(
                                    "Register",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    _authenticate();
                                  },
                                ),
                              ),
                              SizedBox(height: 10,),
                              Expanded(
                                child: Row(
                                  children: [
                                    Text('Already have any account?',style: TextStyle(color: Colors.grey),),
                                    FlatButton(
                                      child: Text('Login!',style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 15),),
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  width: double.infinity,
                  child: isLoading ? SpinKitProgress() : Padding(
                    padding: const EdgeInsets.only(top: 10, left: 30,right: 30),
                    child: Text(_errorMsg,style: TextStyle(color: Colors.red),),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
