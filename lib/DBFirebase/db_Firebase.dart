import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegramchatapp/DBFirebase/Authentication.dart';
import 'package:telegramchatapp/Models/user.dart';

final String COLLECTION_USER = "users";
class DBFirebaseHelper{
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;

  ///For User <------------------------------------------------------------------------>
  static Future<void> insertUser(TUser user) async{
    DocumentReference doc = db.collection(COLLECTION_USER).doc(auth.currentUser.uid);
    user.id = auth.currentUser.uid;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("id", user.id);

    return doc.set(user.toMap());
  }

  static Future<List<TUser>> getAllUsers() async{
    List<TUser> users = [];
    QuerySnapshot snapshot = await db.collection(COLLECTION_USER).where("id", isNotEqualTo: AuthenticationService.getCurrentUser().uid).get();
    if(snapshot != null){
      users = snapshot.docs.map((doc) =>TUser.fromMap(doc.data())).toList();
    }
    return users;
  }
  static Future<void> deleteUser(String userId) async{
    return db.collection(COLLECTION_USER).doc(userId).delete();
  }

  static Future<void> updatePhoto(String userId, String imageUrl)async{
    final doc = db.collection(COLLECTION_USER).doc(userId);
    return doc.update({"photoUrl" : imageUrl});
  }
  static Future<void> UpdateBio(String userId, String value)async{
    final doc = db.collection(COLLECTION_USER).doc(userId);
    return doc.update({"aboutme" : value});
  }

  static Future<void> UpdateName(String userId, String value)async{
    final doc = db.collection(COLLECTION_USER).doc(userId);
    return doc.update({"nickname" : value});
  }
  static Future<void> UpdateworkAt(String userId, String value)async{
    final doc = db.collection(COLLECTION_USER).doc(userId);
    return doc.update({"workAt" : value});
  }
  static Future<void> UpdateUniversity(String userId, String value)async{
    final doc = db.collection(COLLECTION_USER).doc(userId);
    return doc.update({"university" : value});
  }
  static Future<void> UpdateHighschool(String userId, String value)async{
    final doc = db.collection(COLLECTION_USER).doc(userId);
    return doc.update({"highschool" : value});
  }
  static Future<void> Updateschool(String userId, String value)async{
    final doc = db.collection(COLLECTION_USER).doc(userId);
    return doc.update({"school" : value});
  }
  static Future<void> UpdateGender(String userId, String value)async{
    final doc = db.collection(COLLECTION_USER).doc(userId);
    return doc.update({"gender" : value});
  }
  static Future<void> UpdateHomeTowne(String userId, String value)async{
    final doc = db.collection(COLLECTION_USER).doc(userId);
    return doc.update({"homeTowen" : value});
  }

  static Future<TUser> getUserById(String userId) async{
    final snapshot = await db.collection(COLLECTION_USER).doc(userId).get();
    return TUser.fromMap(snapshot.data());
  }
  static Future<List<TUser>> getUserByName(String userName) async{
    List<TUser> users = [];
    final snapshot = await db.collection(COLLECTION_USER).where("nickname", isEqualTo: userName).get();
    if(snapshot != null){
      users = snapshot.docs.map((doc) =>TUser.fromMap(doc.data())).toList();
   }
    return users;
  }


  /// For Message <--------------------------------------------------------------->


}