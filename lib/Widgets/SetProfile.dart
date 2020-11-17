
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telegramchatapp/DBFirebase/db_Firebase.dart';
import 'package:telegramchatapp/Models/user.dart';
import 'package:telegramchatapp/Pages/HomePage.dart';
import 'package:telegramchatapp/Widgets/ProgressWidget.dart';

class InitilizeProfile extends StatefulWidget {
  final String userID;

  InitilizeProfile({
    Key key, @required this.userID
  }):super(key : key);
  @override
  _InitilizeProfileState createState() => _InitilizeProfileState(userId : userID);
}

class _InitilizeProfileState extends State<InitilizeProfile> {
  final String userId;

  _InitilizeProfileState({
    Key key, @required this.userId
  });

  @override
  void initState() {
    setState(() {

    });
    super.initState();
  }
  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
  }

  final _formKey = GlobalKey<FormState>();
  TUser user;
  String aboutme;
  String _imagePath;
  String imageUrl;
  bool isLoading = false;
  String ErrorMsg = '';

  _authenticate() async{
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      try{
        await DBFirebaseHelper.UpdateBio(userId, aboutme);
        await DBFirebaseHelper.updatePhoto(userId, imageUrl).then((_){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
        });
      }catch(error){
        ErrorMsg = error.message;
      }
    }
  }

  Future getImage() async{
     await ImagePicker().getImage(source: ImageSource.gallery).then((imageFile){
       setState(() {
         _imagePath = imageFile.path;
         isLoading = true;
         upLoadImageToFireStore();
       });
    });
  }
  Future upLoadImageToFireStore() async{
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference rootRef = FirebaseStorage.instance.ref();
    StorageReference photoRef = rootRef.child("User_Image").child(fileName);
    final upLoadTask = photoRef.putFile(File(_imagePath));
    final snapshot = await upLoadTask.onComplete;
     final url = await snapshot.ref.getDownloadURL();
     setState(() {
       isLoading = false;
       imageUrl = url;
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Center(
                  child: Text("Welcome To E-Pigeon",
                    style: TextStyle(fontSize: 30,color: Colors.lightBlueAccent),)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                  child: Text("Please SetUp Your Profile",
                    style: TextStyle(fontSize: 15,color: Colors.green),)),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(left: 30, top: 20, right: 30,),
                height: 350,
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
                  padding: const EdgeInsets.only(top: 30, left: 20,right: 20),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2,color: Colors.lightBlueAccent),
                          borderRadius: BorderRadius.circular(20),
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
                      SizedBox(height: 15,),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            labelText: "Set Your Status",
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                isLoading = false;
                              });
                              return "Status Should't be empty!";
                            }
                          },
                          onSaved: (value){
                            aboutme = value;
                          },
                        ),
                      ),
                      SizedBox(height: 15,),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          "Set Profile",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          print(userId);
                          _authenticate();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Text(ErrorMsg),
            Container(
              height: 100,
              width: double.infinity,
              child: isLoading ? SpinKitProgress() : Container(),
            )
          ],
        ),
      ),
    );
  }
}
