import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telegramchatapp/DBFirebase/Authentication.dart';
import 'package:telegramchatapp/DBFirebase/db_Firebase.dart';
import 'package:telegramchatapp/Models/user.dart';
import 'package:telegramchatapp/Widgets/ProgressWidget.dart';
import 'package:telegramchatapp/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0.0,
        title: Text(
          "Update Profile",
          style: TextStyle(
            color: Colors.white,fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SettingsScreen(),
    );
  }
}
class SettingsScreen extends StatefulWidget {
  @override
  State createState() => SettingsScreenState();
}
class SettingsScreenState extends State<SettingsScreen> {
  TextEditingController nicknameTextEditingController;
  TextEditingController aboutTextEditingController;
  TextEditingController workAtTextEditingController;
  TextEditingController universityTextEditingController;
  TextEditingController highschoolTextEditingController;
  TextEditingController schoolTextEditingController;
  TextEditingController genderTextEditingController;
  TextEditingController homeTextEditingController;
  String id = "";
  String imageUrl;
  String nickname = "";
  String workat = "";
  String university = "";
  String highschool = "";
  String school = "";
  String gender = "";
  String hometown = "";
  String aboutme = "";
  String photoUrl = "";
  String imageFileAvatar;
  bool isLoading = false;
  final FocusNode nicknameFocusNode = FocusNode();
  final FocusNode aboutMeFocusNode = FocusNode();
  final FocusNode workAtMeFocusNode = FocusNode();
  final FocusNode universityMeFocusNode = FocusNode();
  final FocusNode highschoolMeFocusNode = FocusNode();
  final FocusNode schoolFocusNode = FocusNode();
  final FocusNode genderFocusNode = FocusNode();
  final FocusNode homeFocusNode = FocusNode();
  @override
  void initState() {
    id = FirebaseAuth.instance.currentUser.uid;
    super.initState();
  }
  void readDataFromLocal() async{

    setState(() {

    });
  }

  Future getImage() async{
     await ImagePicker().getImage(source: ImageSource.gallery).then((newImagefile){
       if(newImagefile != null){
         setState(() {
           imageFileAvatar = newImagefile.path;
           isLoading = true;
           uploadImageToFirestoreAndForebase();
         });
       }
     });
  }
  Future uploadImageToFirestoreAndForebase() async{
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference rootRef = FirebaseStorage.instance.ref();
    StorageReference photoRef = rootRef.child("User_Image").child(fileName);
    final upLoadTask = photoRef.putFile(File(imageFileAvatar));
    final snapshot = await upLoadTask.onComplete;
    final url = await snapshot.ref.getDownloadURL();
    setState(() {
      isLoading = false;
      imageUrl = url;
      DBFirebaseHelper.updatePhoto(id, imageUrl);
    });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:DBFirebaseHelper.getUserById(AuthenticationService.auth.currentUser.uid),
      builder: (context, AsyncSnapshot<TUser> snapshot){
        if(snapshot.hasData){
          nicknameTextEditingController = TextEditingController(text: snapshot.data.nickname);
          aboutTextEditingController = TextEditingController(text: snapshot.data.aboutme);
          workAtTextEditingController = TextEditingController(text: snapshot.data.workAt);
          universityTextEditingController = TextEditingController(text: snapshot.data.university);
          highschoolTextEditingController = TextEditingController(text: snapshot.data.highschool);
          schoolTextEditingController = TextEditingController(text: snapshot.data.school);
          genderTextEditingController = TextEditingController(text: snapshot.data.gender);
          homeTextEditingController = TextEditingController(text: snapshot.data.homeTowen);
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 300,
                      width: double.infinity,
                      //width: 200,
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          )

                      ),
                      child: Center(
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white,width: 5),
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              (imageFileAvatar == null) ?
                              (snapshot.data.photoUrl != "") ? Material(
                                ///Show Exesting Image
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                                    ),
                                    width: 200,
                                    height: 200,
                                    padding: EdgeInsets.all(20),
                                  ),
                                  imageUrl: snapshot.data.photoUrl,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(125)),
                                clipBehavior: Clip.hardEdge,
                              ) :
                              Icon(Icons.account_circle,size: 90,color: Colors.grey,) :
                              Material(
                                child: Image.file(
                                  File(imageFileAvatar),
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(125)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              IconButton(
                                icon: Icon(Icons.camera_alt,color: Colors.lightBlueAccent.withOpacity(0.9),size: 80,),
                                onPressed: getImage,
                                padding: EdgeInsets.all(0.0),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.grey,
                                iconSize: 200,
                              ),
                            ],
                          ),
                        ),
                      ),
                      //margin: EdgeInsets.all(20),
                    ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.lightBlueAccent,width: 2),
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                width: MediaQuery.of(context).size.width*0.6,
                                height: MediaQuery.of(context).size.width*0.17,
                                child: Theme(
                                  data: Theme.of(context).copyWith(primaryColor: Colors.lightBlueAccent),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        hintText: 'e.g Jhon',
                                        contentPadding: EdgeInsets.all(5),
                                        hintStyle: TextStyle(color: Colors.grey)
                                    ),
                                    controller: nicknameTextEditingController,
                                    onChanged: (value){
                                      nickname = value;
                                    },
                                    focusNode: nicknameFocusNode,
                                  ),
                                ),
                                margin: EdgeInsets.only(left: 30),
                              ),
                              FlatButton(
                                child: Text("Update",style: TextStyle(color: Colors.lightBlueAccent),),
                                onPressed: (){
                                  if(nickname.isEmpty){
                                    Fluttertoast.showToast(msg: "Can not Update Name");
                                  }else{
                                    isLoading = true;
                                    DBFirebaseHelper.UpdateName(id, nickname).then((_){
                                      Fluttertoast.showToast(msg: "Name Update Successfully");
                                      isLoading = false;
                                    });
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                    Container(
                      margin: EdgeInsets.only(left: 30,right: 30,top: 15),
                       height: MediaQuery.of(context).size.width*0.28,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightBlueAccent,width: 2),
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                  hintText: 'My Bio..',
                                  contentPadding: EdgeInsets.all(5),
                                  hintStyle: TextStyle(color: Colors.grey)
                              ),
                              controller: aboutTextEditingController,
                              onChanged: (value){
                                aboutme = value;
                              },
                              focusNode: aboutMeFocusNode,
                            ),
                            FlatButton(
                              child: Text("Update Bio",style: TextStyle(color: Colors.lightBlueAccent),),
                              onPressed: (){
                                if(aboutme.isEmpty){
                                  Fluttertoast.showToast(msg: "Can not Update Bio");
                                }else{
                                  isLoading = true;
                                  DBFirebaseHelper.UpdateBio(id, aboutme).then((_){
                                    Fluttertoast.showToast(msg: "Bio Update Successfully");
                                    isLoading = false;
                                  });
                                }
                              },
                            )
                          ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30,right: 30,top: 15),
                      height: MediaQuery.of(context).size.width*0.28,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.lightBlueAccent,width: 2),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                                hintText: 'Works Status',
                                contentPadding: EdgeInsets.all(5),
                                hintStyle: TextStyle(color: Colors.grey)
                            ),
                            controller: workAtTextEditingController,
                            onChanged: (value){
                              workat = value;
                            },
                            focusNode: workAtMeFocusNode,
                          ),
                          FlatButton(
                            child: Text("Update Work at",style: TextStyle(color: Colors.lightBlueAccent),),
                            onPressed: (){
                              if(workat.isEmpty){
                                Fluttertoast.showToast(msg: "Can not Update Work Status");
                              }else{
                                isLoading = true;
                                DBFirebaseHelper.UpdateworkAt(id, workat).then((_){
                                  Fluttertoast.showToast(msg: "Work Status Update Successfully");
                                  isLoading = false;
                                });
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30,right: 30,top: 15),
                      height: MediaQuery.of(context).size.width*0.28,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.lightBlueAccent,width: 2),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                                hintText: 'University',
                                contentPadding: EdgeInsets.all(5),
                                hintStyle: TextStyle(color: Colors.grey)
                            ),
                            controller: universityTextEditingController,
                            onChanged: (value){
                              university = value;
                            },
                            focusNode: universityMeFocusNode,
                          ),
                          FlatButton(
                            child: Text("Update University",style: TextStyle(color: Colors.lightBlueAccent),),
                            onPressed: (){
                              if(university.isEmpty){
                                Fluttertoast.showToast(msg: "Can not Update University");
                              }else{
                                isLoading = true;
                                DBFirebaseHelper.UpdateUniversity(id, university).then((_){
                                  Fluttertoast.showToast(msg: "University Update Successfully");
                                  isLoading = false;
                                });
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30,right: 30,top: 15),
                      height: MediaQuery.of(context).size.width*0.28,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.lightBlueAccent,width: 2),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                                hintText: 'High School/College',
                                contentPadding: EdgeInsets.all(5),
                                hintStyle: TextStyle(color: Colors.grey)
                            ),
                            controller: highschoolTextEditingController,
                            onChanged: (value){
                              highschool = value;
                            },
                            focusNode: highschoolMeFocusNode,
                          ),
                          FlatButton(
                            child: Text("Update HighSchool",style: TextStyle(color: Colors.lightBlueAccent),),
                            onPressed: (){
                              if(highschool.isEmpty){
                                Fluttertoast.showToast(msg: "Can not Update HighSchool");
                              }else{
                                isLoading = true;
                                DBFirebaseHelper.UpdateHighschool(id, highschool).then((_){
                                  Fluttertoast.showToast(msg: "HighSchool Update Successfully");
                                  isLoading = false;
                                });
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30,right: 30,top: 15),
                      height: MediaQuery.of(context).size.width*0.28,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.lightBlueAccent,width: 2),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                                hintText: 'School',
                                contentPadding: EdgeInsets.all(5),
                                hintStyle: TextStyle(color: Colors.grey)
                            ),
                            controller: schoolTextEditingController,
                            onChanged: (value){
                              school = value;
                            },
                            focusNode: schoolFocusNode,
                          ),
                          FlatButton(
                            child: Text("Update School",style: TextStyle(color: Colors.lightBlueAccent),),
                            onPressed: (){
                              if(school.isEmpty){
                                Fluttertoast.showToast(msg: "Can not Update School");
                              }else{
                                isLoading = true;
                                DBFirebaseHelper.Updateschool(id, school).then((_){
                                  Fluttertoast.showToast(msg: "School Update Successfully");
                                  isLoading = false;
                                });
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30,right: 30,top: 15),
                      height: MediaQuery.of(context).size.width*0.28,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.lightBlueAccent,width: 2),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                                hintText: 'Gender',
                                contentPadding: EdgeInsets.all(5),
                                hintStyle: TextStyle(color: Colors.grey)
                            ),
                            controller: genderTextEditingController,
                            onChanged: (value){
                              gender = value;
                            },
                            focusNode: genderFocusNode,
                          ),
                          FlatButton(
                            child: Text("Update Gender",style: TextStyle(color: Colors.lightBlueAccent),),
                            onPressed: (){
                              if(gender.isEmpty){
                                Fluttertoast.showToast(msg: "Can not Update Gender");
                              }else{
                                isLoading = true;
                                DBFirebaseHelper.UpdateGender(id, gender).then((_){
                                  Fluttertoast.showToast(msg: "Gender Update Successfully");
                                  isLoading = false;
                                });
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30,right: 30,top: 15,bottom: 20),
                      height: MediaQuery.of(context).size.width*0.28,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.lightBlueAccent,width: 2),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                                hintText: 'Home Towne',
                                contentPadding: EdgeInsets.all(5),
                                hintStyle: TextStyle(color: Colors.grey)
                            ),
                            controller: homeTextEditingController,
                            onChanged: (value){
                              hometown = value;
                            },
                            focusNode: homeFocusNode,
                          ),
                          FlatButton(
                            child: Text("Update HomeTowne",style: TextStyle(color: Colors.lightBlueAccent),),
                            onPressed: (){
                              if(hometown.isEmpty){
                                Fluttertoast.showToast(msg: "Can not Update HomeTowne");
                              }else{
                                isLoading = true;
                                DBFirebaseHelper.UpdateHomeTowne(id, hometown).then((_){
                                  Fluttertoast.showToast(msg: "HomeTowne Update Successfully");
                                  isLoading = false;
                                });
                              }
                            },
                          )
                        ],
                      ),
                    ),
                      ],
                ),
              ),
            ],
          );
        }
      },

    );
  }
}

