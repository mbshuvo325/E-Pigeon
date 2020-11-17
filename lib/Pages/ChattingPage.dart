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
import 'package:telegramchatapp/Widgets/ViewUsersProfile.dart';

class Chat extends StatelessWidget {

  final String riciverId;
  final String riciverName;
  final String senderId;
  final String imageUrl;

  Chat({
    Key key,
    @required this.riciverId,
    @required this.riciverName,
    @required this.imageUrl,
    @required this.senderId
});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewProfile(userID: riciverId)));
            },
            child: Padding(
              padding: EdgeInsets.all(8),
              child: imageUrl!= null ?  CircleAvatar(
                backgroundColor: Colors.black,
                backgroundImage: CachedNetworkImageProvider(imageUrl),
              ): Icon(Icons.account_circle,size: 50,color: Colors.white,)
            ),
          ),
        ],
        title: Text(riciverName,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ChatScreen(reciverId: riciverId, reciverName: riciverName,senderId: senderId,imageUrl: imageUrl,),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String reciverId;
  final String reciverName;
  final String imageUrl;
  final String senderId;

  ChatScreen({
    Key key,
    @required this.reciverId,
    @required this.reciverName,
    @required this.imageUrl,
    @required this.senderId
  }) : super(key : key);
  @override
  State createState() => ChatScreenState(reciverId: reciverId, reciverName: reciverName, senderId: senderId,imageUrl: imageUrl);
}

class ChatScreenState extends State<ChatScreen> {
  final String reciverId;
  final String reciverName;
  final String imageUrl;
  final String senderId;

  ChatScreenState({
    Key key,
    @required this.reciverId,
    @required this.reciverName,
    @required this.imageUrl,
    @required this.senderId
  });
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  bool isDisplaySticker;
  bool isLoading;
  String imageUrlF = '';

  String chatId;
  String id;
  var listMessage;
  SharedPreferences preferences;

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
    preferences = await SharedPreferences.getInstance();
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
        collection("message").doc(chatId).collection(chatId).
        orderBy("timestamp", descending: true).
        limit(20).snapshots(),

        builder: (context, snapshot){
          if(!snapshot.hasData){
             return Center(
              child: SpinKitProgress(),
               
            );
          }else{
            listMessage = snapshot.data.docs;
            print(listMessage.length);
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemBuilder: (context, index) => messageItem(index, snapshot.data.docs[index]),
              itemCount: snapshot.data.docs.length,
              reverse: true,
              controller: scrollController,
            );
          }
        },
      )
    );
  }

  Widget messageItem(int index, DocumentSnapshot doc){
    //sender Side - Righ
    if(doc['idFrom'] == id){
      return Row(
        children: [
          doc["type"] == 0
          //for Text-message
              ? Container(
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(20.0),
                   ),
                //width: 200,
            child: Text(doc["content"],style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,),),
            margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0 , right: 10.0),
          ) :
              doc["type"] == 1
              //for image message
              ? Container(
                child: FlatButton(
                  child: Material(
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: Center(
                          child: SpinKitProgress(),
                        ),
                        height: 200,
                        width: 200,
                        padding: EdgeInsets.all(70),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      errorWidget: (context,url,error) => Material(
                        child: Image.asset("images/img_not_available.jpeg",width: 200,height: 200,fit: BoxFit.cover,),
                          borderRadius: BorderRadius.circular(8),
                          clipBehavior: Clip.hardEdge,
                      ),
                      imageUrl: doc["content"],
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    clipBehavior: Clip.hardEdge,
                  ),
                  onPressed: (){
                    Fluttertoast.showToast(msg: "For Full Photo");
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => FullPhoto(url: doc["content"])));
                  },
                ),
                margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0 , right: 10.0),
              )
              //for sticker-gif message
                  : Container(
                child: Image.asset("images/${doc["content"]}.gif",
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,),
                margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0 , right: 10.0),
              ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    }
    //reciver Side- left
    else{
      return Container(
        child: Column(
          children: [
            Row(
              children: [
                isLastMessageLeft(index)
                    ? imageUrl != null ? Material(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: Center(
                          child: SpinKitProgress(),
                        ),
                        height: 20,
                        width: 20,
                        padding: EdgeInsets.all(8),
                        ),
                       imageUrl: imageUrl,
                       height: 20,
                       width: 20,
                       fit: BoxFit.cover,
                      ),
                  ),
                    borderRadius: BorderRadius.circular(18),
                    ) : Icon(Icons.account_circle,size: 20,color: Colors.lightBlueAccent,)
                    : Container(width: 20,),

                ///Display Left-side message

                  doc["type"] == 0
                //for Text-message
                    ? Container(
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  //width: 200,
                  child: Text(doc["content"],style: TextStyle(color: Colors.white54,fontWeight: FontWeight.w400,),),
                  margin: EdgeInsets.only(left: 10),
                )
                    : doc["type"] == 1
                //for image message
                    ? Container(
                  child: FlatButton(
                    child: Material(
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: Center(
                            child: SpinKitProgress(),
                          ),
                          height: 200,
                          width: 200,
                          padding: EdgeInsets.all(70),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8)
                          ),
                        ),
                        errorWidget: (context,url,error) => Material(
                          child: Image.asset("images/img_not_available.jpeg",width: 200,height: 200,fit: BoxFit.cover,),
                          borderRadius: BorderRadius.circular(8),
                          clipBehavior: Clip.hardEdge,
                        ),
                        imageUrl: doc["content"],
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      clipBehavior: Clip.hardEdge,
                    ),
                    onPressed: (){
                      Fluttertoast.showToast(msg: "For Full Photo");
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => FullPhoto(url: doc["content"])));
                    },
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                )
                //for sticker-gif message
                    : Container(
                  child: Image.asset("images/${doc["content"]}.gif",
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,),
                  margin: EdgeInsets.only(left: 10),
                ),
              ],
            ),
            
            isLastMessageLeft(index) ? Container(
              child: Text(DateFormat("dd MMMM, yyyy - hh:mm:aa").format(DateTime.fromMicrosecondsSinceEpoch(int.parse(doc['timestamp']))),
                style: TextStyle(color: Colors.grey,fontSize: 12,fontStyle: FontStyle.italic),
              ),
              margin: EdgeInsets.only(left: 80,top: 30,bottom: 5.0),
            ) : Container(width: 0.0, height: 0.0,),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10),
      );
    }
  }

  bool isLastMessageRight(int index){
    if(index > 0 && listMessage != null && listMessage[index-1]["idFrom"] != id || index==0){
      return true;
    }
    else{
      return false;
    }
  }
  bool isLastMessageLeft(int index){
    if(index > 0 && listMessage != null && listMessage[index-1]["idFrom"] == id || index==0){
      return true;
    }
    else{
      return false;
    }
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
        setState(() {
          imageUrlF = imageFile.path;
          isLoading = true;
          upLoadImageToFireStore();
        });
      }
    });
  }
  Future upLoadImageToFireStore() async{
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference rootRef = FirebaseStorage.instance.ref();
    StorageReference photoRef = rootRef.child("Chat_Image").child(fileName);
    final upLoadTask = photoRef.putFile(File(imageUrlF));
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
       var docRef = FirebaseFirestore.instance.collection("message").doc(chatId)
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
