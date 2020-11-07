import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        backgroundColor: Colors.lightBlue,
        title: Text(
          "Account Setting",
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
  SharedPreferences sharedPreferences;
  String id = "";
  String nickname = "";
  String aboutme = "";
  String photoUrl = "";
  File imageFileAvatar;
  bool isLoading = false;
  final FocusNode nicknameFocusNode = FocusNode();
  final FocusNode aboutMeFocusNode = FocusNode();
  @override
  void initState() {
    readDataFromLocal();
    super.initState();
  }
  void readDataFromLocal() async{
    sharedPreferences = await SharedPreferences.getInstance();
    id = sharedPreferences.getString("id");
    nickname = sharedPreferences.getString("nickname");
    aboutme = sharedPreferences.getString("aboutme");
    photoUrl = sharedPreferences.getString("photoUrl");
    nicknameTextEditingController = TextEditingController(text: nickname);
    aboutTextEditingController = TextEditingController(text: aboutme);
    setState(() {

    });
  }

  Future getImage() async{
    File newImagefile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(newImagefile != null){
      setState(() {
        imageFileAvatar = newImagefile;
        isLoading = true;
      });
    }
    uploadImageToFirestoreAndForebase();
  }

  Future uploadImageToFirestoreAndForebase() async{
    String mFileName = id;
    StorageReference storageReference = FirebaseStorage.instance.ref().child(mFileName);
    StorageUploadTask storageUploadTask = storageReference.putFile(imageFileAvatar);
    StorageTaskSnapshot storageTaskSnapshot;
    storageUploadTask.onComplete.then((value){
      if(value.error == null){
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((imageDownloadUrl){
          photoUrl = imageDownloadUrl;
          FirebaseFirestore.instance.collection("users").doc(id).update({
            "photoUrl" : photoUrl,
            "nickname" : nickname,
            "aboutme" : aboutme,
          }).then((value) async{
            await sharedPreferences.setString("photoUrl", photoUrl);
            setState(() {
              isLoading =false;
            });
            Fluttertoast.showToast(msg: "Update Successfully");
          });
        },onError: (ErrorMsg){
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: "Faild To get Image");
        });
      }
    },onError:(ErrorMsg){
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: ErrorMsg);
    });
  }

  void upDateUserProfile(){
    nicknameFocusNode.unfocus();
    aboutMeFocusNode.unfocus();
    setState(() {
      isLoading = false;
    });
    FirebaseFirestore.instance.collection("users").doc(id).update({
      "photoUrl" : photoUrl,
      "nickname" : nickname,
      "aboutme" : aboutme,
    }).then((value) async{
      await sharedPreferences.setString("photoUrl", photoUrl);
      await sharedPreferences.setString("nickname", nickname);
      await sharedPreferences.setString("aboutme", aboutme);
      setState(() {
        isLoading =false;
      });
      Fluttertoast.showToast(msg: "Update Successfully");
    });
  }
  final googleSignIn = GoogleSignIn();
  Future<Null> logOutUser() async{
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyApp()), (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
             Container(
               child: Center(
                 child: Stack(
                   children: [
                     (imageFileAvatar == null) ?
                     (photoUrl != "") ? Material(
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
                         imageUrl: photoUrl,
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
                         imageFileAvatar,
                         width: 200,
                         height: 200,
                         fit: BoxFit.cover,
                       ),
                       borderRadius: BorderRadius.all(Radius.circular(125)),
                       clipBehavior: Clip.hardEdge,
                     ),
                          IconButton(
                           icon: Icon(Icons.camera_alt,color: Colors.white54.withOpacity(0.3),size: 100,),
                           onPressed: getImage,
                           padding: EdgeInsets.all(0.0),
                           splashColor: Colors.transparent,
                           highlightColor: Colors.grey,
                           iconSize: 200,
                       ),
                   ],
                 ),
               ),
               width: double.infinity,
               margin: EdgeInsets.all(20),
             ),
              Column(
                children: [
                  Padding(padding: EdgeInsets.all(10),child: isLoading ? circularProgress() : Container(),),
                  Container(
                    child: Text('Profile Name',
                      style: TextStyle(fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.lightBlueAccent),),
                    margin: EdgeInsets.only(left: 10,bottom: 5,top: 10),
                  ),
                  Container(
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
                    margin: EdgeInsets.only(left: 30,right: 30),
                  ),

                  Container(
                    child: Text('About Me',
                      style: TextStyle(fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.lightBlueAccent),),
                    margin: EdgeInsets.only(left: 10,bottom: 5,top: 30),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context).copyWith(primaryColor: Colors.lightBlueAccent),
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Bio..',
                            contentPadding: EdgeInsets.all(5),
                            hintStyle: TextStyle(color: Colors.grey)
                        ),
                        controller: aboutTextEditingController,
                        onChanged: (value){
                          aboutme = value;
                        },
                        focusNode: aboutMeFocusNode,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30,right: 30),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              Container(
                child: FlatButton(
                  child: Text(
                    "Update",style: (TextStyle(fontSize: 16)),
                  ),
                  onPressed: (){
                    upDateUserProfile();
                  },
                  color: Colors.lightBlueAccent,
                  highlightColor: Colors.grey,
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                ),
                margin: EdgeInsets.only(top: 50,bottom: 1.0),
              ),
              Padding(
                padding: EdgeInsets.only(left: 50,right: 50),
                child: RaisedButton(
                  child: Text('Logout',style: TextStyle(color: Colors.white,fontSize: 14),),
                  color: Colors.red,
                  onPressed: (){
                    logOutUser();
                  },
                ),
              )
            ],
          ),
          padding: EdgeInsets.only(left: 15,right: 15),
        ),
      ],
    );
  }
}

