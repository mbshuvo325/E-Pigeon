
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegramchatapp/Models/user.dart';

class AuthenticationService{
  SharedPreferences preferences;
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static User getCurrentUser()  =>  auth.currentUser;
  static Future<String>login(String email, String password) async{
    final credintial = await  auth.signInWithEmailAndPassword(email: email, password: password);
    return credintial.user.uid;
  }
  static Future<String>register(String email, String password) async{
    final credintial = await  auth.createUserWithEmailAndPassword(email: email, password: password);
    return credintial.user.uid;
  }
  static Future<void>logOut() async{
    await auth.signOut();
  }

}