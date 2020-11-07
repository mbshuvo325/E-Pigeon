import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:telegramchatapp/Widgets/FullImageWidget.dart';
import 'package:telegramchatapp/Widgets/ProgressWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatelessWidget {

  final String riciverId;
  final String riciverName;
  final String senderId;

  Chat({
    Key key,
    @required this.riciverId,
    @required this.riciverName,
    @required this.senderId
});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          Padding(
            padding: EdgeInsets.all(5),
            child: CircleAvatar(
              backgroundColor: Colors.black,
            ),
          ),
          /*Padding(
            padding: EdgeInsets.all(5),
            child: IconButton(
              icon: Icon(Icons.info,color: Colors.pink,),
              onPressed: (){

              },
            ),
          )*/
        ],
        title: Text(riciverName,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ChatScreen(reciverId: riciverId, reciverName: riciverName,senderId: senderId,),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String reciverId;
  final String reciverName;
  final String senderId;

  ChatScreen({
    Key key,
    @required this.reciverId,
    @required this.reciverName,
    @required this.senderId
  }) : super(key : key);
  @override
  State createState() => ChatScreenState(reciverId: reciverId, reciverName: reciverName, senderId: senderId);
}

class ChatScreenState extends State<ChatScreen> {
  final String reciverId;
  final String reciverName;
  final String senderId;

  ChatScreenState({
    Key key,
    @required this.reciverId,
    @required this.reciverName,
    @required this.senderId
  });
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  bool isDisplaySticker;
  bool isLoading;
  String imageUrl = '';

  String chatId;
  String id;
  var listMessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(onFucusChange);
    isDisplaySticker = false;
    isLoading = false;

    chatId = "";
    readLocal();
  }

  readLocal() async{
    id = senderId;
    if(id.hashCode <= reciverId.hashCode){
      chatId = '$id-$reciverId';
    }else{
      chatId = '$reciverId-$id';
    }
    FirebaseFirestore.instance.collection("users").doc(id).update({"chattingWith" : reciverId});
    setState(() {

    });
  }

  onFucusChange(){
    if(focusNode.hasFocus){
      setState(() {
        isDisplaySticker = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: [
          Column(
            children: [

           createListMessage(),

          (isDisplaySticker ? createSticker() : Container()),
          ///For Input
          crateInput(),
          ],
        ),
          createLoading(),
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  createLoading(){

    return Positioned(
      child: isLoading ? SpinKitProgress() : Container(),
    );
  }

  Future<bool>onBackPress(){
   if(isDisplaySticker){
     setState(() {
       isDisplaySticker = false;
     });
   }
   else{
     Navigator.of(context).pop();
   }
   return Future.value(false);
  }

  createSticker(){
    return Container(
      decoration: BoxDecoration(border: Border(
        top: BorderSide(color: Colors.grey, width: 0.5)
      ),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(5),
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                onPressed: (){
                  onSendMessage("mimi1", 2);
                  Fluttertoast.showToast(msg: "mimi1");
                },
                child: Image.asset(
                  "images/mimi1.gif",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: (){
                  onSendMessage("mimi2", 2);
                  Fluttertoast.showToast(msg: "mimi2");
                },
                child: Image.asset(
                  "images/mimi2.gif",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: (){
                  onSendMessage("mimi3", 2);
                  Fluttertoast.showToast(msg: "mimi3");
                },
                child: Image.asset(
                  "images/mimi3.gif",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                onPressed: (){
                  onSendMessage("mimi4", 2);
                  Fluttertoast.showToast(msg: "mimi4");
                },
                child: Image.asset(
                  "images/mimi4.gif",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: (){
                  onSendMessage("mimi5", 2);
                  Fluttertoast.showToast(msg: "mimi5");
                },
                child: Image.asset(
                  "images/mimi5.gif",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: (){
                  onSendMessage("mimi6", 2);
                  Fluttertoast.showToast(msg: "mimi6");
                },
                child: Image.asset(
                  "images/mimi6.gif",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                onPressed: (){
                  onSendMessage("mimi7", 2);
                  Fluttertoast.showToast(msg: "mimi7");
                },
                child: Image.asset(
                  "images/mimi7.gif",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: (){
                  onSendMessage("mimi8", 2);
                  Fluttertoast.showToast(msg: "mimi8");
                },
                child: Image.asset(
                  "images/mimi8.gif",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: (){
                  onSendMessage("mimi9", 2);
                  Fluttertoast.showToast(msg: "mimi9");
                },
                child: Image.asset(
                  "images/mimi9.gif",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  createListMessage(){
    return Flexible(
      child: chatId == "" ? Center(
        child: SpinKitProgress(),
      ) : StreamBuilder(
        stream: FirebaseFirestore.instance.
        collection("message").doc(chatId).
        collection(chatId).
        orderBy("timestamp", descending: true).
        limit(20).snapshots(),

        builder: (context, snapshot){
          if(!snapshot.hasData){
            Center(
              child: SpinKitProgress(),
            );
          }else{
            listMessage = snapshot.data.doc;
            return ListView.builder(
              padding: EdgeInsets.all(8),
              //itemBuilder: (context, index) => messageItem(index, snapshot.data.doc[index]) ,
              itemCount: snapshot.data.doc.length,
              reverse: true,
              controller: scrollController,
            );
          }
        },
      )
    );
  }

  void getEmoji(){
    focusNode.unfocus();
    setState(() {
      isDisplaySticker =! isDisplaySticker;
    });
  }
  Future getImage() async{
    await ImagePicker().getImage(source: ImageSource.gallery).then((imageFile){
      if(imageFile != null){
        isLoading = true;
      }
      imageUrl = imageFile.path;
      upLoadImageToFireStore();

    });
  }
  Future upLoadImageToFireStore() async{
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference rootRef = FirebaseStorage.instance.ref();
    StorageReference photoRef = rootRef.child("Chat_Image").child(fileName);
    final upLoadTask = photoRef.putFile(File(imageUrl));
    final snapshot = await upLoadTask.onComplete;
    final url = await snapshot.ref.getDownloadURL();
    setState(() {
      isLoading = false;
      onSendMessage(url, 1);
    });
  }

  void onSendMessage(String content, int type){
    if(content != ""){
      textEditingController.clear();
       var docRef = FirebaseFirestore.instance.collection("message")
           .doc(chatId)
           .collection(chatId)
           .doc(DateTime.now().millisecondsSinceEpoch.toString());

       FirebaseFirestore.instance.runTransaction((transaction) async{
         await transaction.set(docRef, {
           "idFrom" : id,
           "idTo" : reciverId,
           "timestamp" : DateTime.now().millisecondsSinceEpoch.toString(),
           "content" : content,
           "type" : type,
         },);
       });
       scrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  crateInput() {
    return Container(
      child: Row(
        children: [
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: Icon(Icons.image),
                color: Colors.lightBlueAccent,
                onPressed: (){
                  getImage();
                  //Fluttertoast.showToast(msg: "For Image Pickup");
                },
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: Icon(Icons.face),
                color: Colors.lightBlueAccent,
                onPressed: (){
                  //Fluttertoast.showToast(msg: "For Emoji Pickup");
                  getEmoji();
                },
              ),
            ),
            color: Colors.white,
          ),

          //TextFild For sending text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(
                  color: Colors.black
                ),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                    hintText:"Write Here.....",
                    hintStyle: TextStyle(color: Colors.grey)
                ),
                focusNode: focusNode,
              ),
            ),
          ),
          ///send icon button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: Icon(Icons.send),
                color: Colors.lightBlueAccent,
                onPressed: (){
                  onSendMessage(textEditingController.text, 0);
                  //Fluttertoast.showToast(msg: "For Message Send");
                },
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 0.5
          )
        ),
        color: Colors.white
      ),
    );
  }
}
