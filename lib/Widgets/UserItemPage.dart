import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:telegramchatapp/DBFirebase/Authentication.dart';
import 'package:telegramchatapp/DBFirebase/db_Firebase.dart';
import 'package:telegramchatapp/Models/user.dart';
import 'package:telegramchatapp/Pages/ChattingPage.dart';
import 'package:telegramchatapp/Widgets/SetProfile.dart';
class UserItem extends StatefulWidget {
  final TUser user;
  UserItem(this.user);

  @override
  _UserItemState createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        /*DBFirebaseHelper.deleteUser(widget.user.id).then((value) {
          setState(() {

          });
        });*/
        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => InitilizeProfile()));
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
            Chat(riciverId :widget.user.id , riciverName: widget.user.nickname, senderId: AuthenticationService.getCurrentUser().uid)));
      },
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          margin: EdgeInsets.all(5),
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0,3),
              ),
            ],
          ),
          child: ListTile(
            leading: Container(
              height: 50,
              width: 50,
             decoration: BoxDecoration(
               border: Border.all(color: Colors.grey,width: 2),
               borderRadius: BorderRadius.circular(30)
             ),
              /*child: widget.user.photoUrl == null ? Icon(Icons.account_circle,size: 50,) : CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(widget.user.photoUrl),
              ),*/
            ),
            title: Text(widget.user.nickname),
            subtitle: Text(widget.user.aboutme),
          ),
        ),
      )
    );
  }
}
