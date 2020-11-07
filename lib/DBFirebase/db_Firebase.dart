
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telegramchatapp/Models/user.dart';

final String COLLECTION_USER = "users";
class DBFirebaseHelper{
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<void> insertUser(TUser user) async{
    DocumentReference doc = db.collection(COLLECTION_USER).doc();
    user.id = doc.id;
    return doc.set(user.toMap());
  }

  static Future<List<TUser>> getAllUsers() async{
    List<TUser> users = [];
    QuerySnapshot snapshot = await db.collection(COLLECTION_USER).get();
    if(snapshot != null){
      users = snapshot.docs.map((doc) =>TUser.fromMap(doc.data())).toList();
    }
    return users;
  }

  static Future<void> deleteUser(String userId) async{
    return db.collection(COLLECTION_USER).doc(userId).delete();
  }

  static Future<void> updatePhoto(String userId, String value)async{
    final doc = db.collection(COLLECTION_USER).doc(userId);
    return doc.update({"photoUrl" : value});
  }
  static Future<void> aboutMe(String userId, String value)async{
    final doc = db.collection(COLLECTION_USER).doc(userId);
    return doc.update({"aboutme" : value});
  }
}