import 'package:cloud_firestore/cloud_firestore.dart';
class TUser {
   String id;
   String nickname;
   String photoUrl;
   String createdAt;
   String aboutme;
   //
   String gender;
   String homeTowen;
   String school;
   String highschool;
   String university;
   String workAt;

  TUser({
    this.id,
    this.nickname,
    this.photoUrl,
    this.createdAt,
    this.aboutme,
    ///
    this.gender,
    this.homeTowen,
    this.school,
    this.highschool,
    this.university,
    this.workAt
  });

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      "nickname" : nickname,
      "photoUrl" : photoUrl,
      "createdAt" : createdAt,
      "aboutme" : aboutme,
      //
      "gender" : gender,
      "homeTowen" : homeTowen,
      "school" : school,
      "highschool" : highschool,
      "university" : university,
      "workAt" : workAt
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
    ///
    gender = map["gender"];
    homeTowen = map["homeTowen"];
    school = map["school"];
    highschool = map["highschool"];
    university = map["university"];
    workAt = map["workAt"];

  }

  factory TUser.fromDocument(DocumentSnapshot doc) {
    return TUser(
      id: doc.id,
      photoUrl: doc['photoUrl'],
      nickname: doc['nickname'],
      createdAt: doc['createdAt'],
      gender: doc['gender'],
      homeTowen: doc['homeTowen'],
      school: doc['school'],
      highschool: doc['highschool'],
      university: doc['university'],
      workAt: doc['workAt'],
    );
  }
}