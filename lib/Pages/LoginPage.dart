
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:telegramchatapp/DBFirebase/Authentication.dart';
import 'package:telegramchatapp/Pages/HomePage.dart';
import 'package:telegramchatapp/Pages/RegistrationPage.dart';
import 'package:telegramchatapp/Widgets/ProgressWidget.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool isLogin = true;
  String email = '';
  String password = '';
  String _errorMsg = '';
  String uid;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _authenticate() async{
    if(_formkey.currentState.validate()){
      _formkey.currentState.save();
      try{
        if(isLogin){
          uid = await AuthenticationService.login(email, password);
        }
        if(uid != null){
          isLoading = false;
          Fluttertoast.showToast(msg: 'Login Successfull');
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Image.asset('assets/images/animpigeon.gif',height: 150,width: 200,),
                    //Text('E-Pigeon',style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 82,fontFamily: "Signatra"),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    margin: EdgeInsets.only(left: 30, top: 10, right: 30,),
                    height: 320,//double.infinity,
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
                              Text('Login to e-pigeon',
                                style: TextStyle(color: Theme.of(context)
                                    .primaryColor,fontSize: 25,fontFamily: "Royalacid",fontWeight: FontWeight.bold),),
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
                              SizedBox(height: 10,),
                              Container(
                                width: double.infinity,
                                height: 45,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  color: Theme.of(context).primaryColor,
                                  child: Text(
                                    "Login",
                                    style: TextStyle(color: Colors.white,fontSize: 25),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isLogin = true;
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
                                    Text('Do not have any account?',style: TextStyle(color: Colors.grey),),
                                    FlatButton(
                                      child: Text('Register!',style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 15),),
                                      onPressed: (){
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegistrationScreen()));
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
                    padding: const EdgeInsets.only(top: 10,left: 30,right: 30),
                    child: Text(_errorMsg,style: TextStyle(color: Colors.red),),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
