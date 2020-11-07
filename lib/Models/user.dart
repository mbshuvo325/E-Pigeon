import 'package:cloud_firestore/cloud_firestore.dart';
class TUser {
   String id;
   String nickname;
   String photoUrl;
   String createdAt;
   String aboutme;

  TUser({
    this.id,
    this.nickname,
    this.photoUrl,
    this.createdAt,
    this.aboutme,
  });

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      "nickname" : nickname,
      "photoUrl" : photoUrl,
      "createdAt" : createdAt,
      "aboutme" : aboutme,
    };
    if(id != null){
      map["id"] = id;
    }
    return map;
  }
  TUser.fromMap(Map<String, dynamic> map){
    id = map["id"];
    nickname = map["nickname"];
    photoUrl = map["photoUrl"];
    createdAt = map["createdAt"];
    aboutme = map["aboutme"];
  }

  factory TUser.fromDocument(DocumentSnapshot doc) {
    return TUser(
      id: doc.id,
      photoUrl: doc['photoUrl'],
      nickname: doc['nickname'],
      createdAt: doc['createdAt'],
    );
  }
}