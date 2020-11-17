import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:telegramchatapp/DBFirebase/db_Firebase.dart';
import 'package:telegramchatapp/Models/user.dart';

class ViewProfile extends StatefulWidget {
  final String userID;
  ViewProfile({ Key key, @required this.userID}): super(key : key);

  @override
  _ViewProfileState createState() => _ViewProfileState(userID: userID);
}

class _ViewProfileState extends State<ViewProfile> {
  final String userID;
  _ViewProfileState({ Key key, @required this.userID});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text("User Profile",style: TextStyle(color: Colors.white),),
        elevation: 0.0,
        actions: [
          IconButton(
            splashColor: Colors.white,
            icon: Icon(Icons.settings,color: Colors.white,size: 30,),
            onPressed: (){

            },
          )
        ],
      ),
      body: FutureBuilder(
          future: DBFirebaseHelper.getUserById(userID),
          builder: (context, AsyncSnapshot<TUser> snapshot){
            if(snapshot.hasData){
              return ListView(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 290,
                    decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(100),
                        )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
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
                              child: snapshot.data.photoUrl != null ? Material(
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
                              ) : Icon(Icons.account_circle,size: 150,color: Colors.lightBlueAccent)
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(snapshot.data.nickname,style:
                        TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),)
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.only(top: 10,left: 30,right: 30,bottom: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlueAccent,width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        Text(" Joined on, ${DateFormat("dd MMMM, yyyy")
                            .format(DateTime.fromMicrosecondsSinceEpoch(int.parse(snapshot.data.createdAt)))}",
                          style: TextStyle(color: Colors.lightBlueAccent),),
                        SizedBox(height: 15,),
                        Text("My Bio",style: TextStyle(color: Colors.grey),),
                        SizedBox(height: 10,),
                        Text(snapshot.data.aboutme,style: TextStyle(color: Colors.lightBlueAccent,fontSize: 20),),
                        SizedBox(height: 15,)
                      ],
                    ),
                  ),

                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 5,bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 7,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Icon(Icons.work,size: 30,color: Colors.lightBlueAccent,)),
                              SizedBox(height: 10,),
                              Container(
                                  margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 7,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Icon(Icons.school,size: 30,color: Colors.lightBlueAccent,)),
                              SizedBox(height: 10,),
                              Container(
                                  margin: EdgeInsets.only(top: 170,left: 10,right: 10),
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 7,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Icon(Icons.person,size: 30,color: Colors.lightBlueAccent,)),
                              SizedBox(height: 10,),
                              Container(
                                  margin: EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 7,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Icon(Icons.home,size: 30,color: Colors.lightBlueAccent,)),
                              SizedBox(width: 20,),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width*0.65,
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                                  height: 60,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 7,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: snapshot.data.workAt != null
                                      ? Center(child: Text("Works at - ${snapshot.data.workAt}",
                                    style: TextStyle(color: Colors.lightBlueAccent,fontSize: 15),))
                                      : Center(child: Text("Not set yet!",style: TextStyle(color: Colors.lightBlueAccent)))),
                              Container(
                                  margin: EdgeInsets.only(left: 10,top: 10,right: 10,bottom: 10),
                                  height: 60,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 7,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: snapshot.data.university != null
                                      ? Center(child: Text("Studied at - ${snapshot.data.university}",style: TextStyle(color: Colors.lightBlueAccent),))
                                      : Center(child: Text("Not set yet!",style: TextStyle(color: Colors.lightBlueAccent)))),
                              Container(
                                  margin: EdgeInsets.only(left: 10,top: 10,right: 10,bottom: 10),
                                  height: 60,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 7,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: snapshot.data.highschool != null
                                      ? Center(child: Text("${snapshot.data.highschool}",style: TextStyle(color: Colors.lightBlueAccent),))
                                      : Center(child: Text("Not set yet!",style: TextStyle(color: Colors.lightBlueAccent)))),
                              Container(
                                  margin: EdgeInsets.only(left: 10,top: 10,right: 10,bottom: 10),
                                  height: 60,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 7,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: snapshot.data.school != null
                                      ? Center(child: Text("Studied at :${snapshot.data.school}",style: TextStyle(color: Colors.lightBlueAccent),))
                                      : Center(child: Text("Not set yet!",style: TextStyle(color: Colors.lightBlueAccent)))),
                              Container(
                                  margin: EdgeInsets.all(10),
                                  height: 60,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 7,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: snapshot.data.gender != null
                                      ? Center(child: Text("Gender -${snapshot.data.gender}",style: TextStyle(color: Colors.lightBlueAccent),))
                                      : Center(child: Text("Not set yet!",style: TextStyle(color: Colors.lightBlueAccent)))),
                              Container(
                                  margin: EdgeInsets.only(top: 10,left: 10,bottom: 20,right: 10),
                                  height: 60,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 7,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: snapshot.data.homeTowen != null
                                      ? Center(child: Text("Home Towen -${snapshot.data.homeTowen}",style: TextStyle(color: Colors.lightBlueAccent),))
                                      : Center(child: Text("Not set yet!",style: TextStyle(color: Colors.lightBlueAccent)))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*Column(
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(top: 20,left: 40),
                     child: Row(
                       children: [
                         (snapshot.data.workAt != null) ? Container(
                             height: 60,
                             width: 60,
                             decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(30),
                               boxShadow: [
                                 BoxShadow(
                                   color: Colors.grey.withOpacity(0.5),
                                   spreadRadius: 5,
                                   blurRadius: 7,
                                   offset: Offset(0, 3), // changes position of shadow
                                 ),
                               ],
                             ),
                             child: Icon(Icons.work,size: 30,color: Colors.lightBlueAccent,)): SizedBox(height: 0,),
                         SizedBox(width: 20,),
                         (snapshot.data.workAt != null) ? Container(
                             height: 60,
                             width: 200,
                             decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(40),
                               boxShadow: [
                                 BoxShadow(
                                   color: Colors.grey.withOpacity(0.5),
                                   spreadRadius: 5,
                                   blurRadius: 7,
                                   offset: Offset(0, 3), // changes position of shadow
                                 ),
                               ],
                             ),
                             child: snapshot.data.workAt != null
                                 ? Center(child: Text("Works at - ${snapshot.data.workAt}",
                               style: TextStyle(color: Colors.lightBlueAccent,fontSize: 15),))
                                 : Center(child: Text("Not set yet!",style: TextStyle(color: Colors.lightBlueAccent))))
              : SizedBox(height: 0,),
                       ],
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(top: 20,left: 40),
                     child: Row(
                       children: [
                         (snapshot.data.university != null) ? Container(
                             height: 60,
                             width: 60,
                             decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(30),
                               boxShadow: [
                                 BoxShadow(
                                   color: Colors.grey.withOpacity(0.5),
                                   spreadRadius: 5,
                                   blurRadius: 7,
                                   offset: Offset(0, 3), // changes position of shadow
                                 ),
                               ],
                             ),
                             child: Icon(Icons.school,size: 30,color: Colors.lightBlueAccent,)): SizedBox(height: 0,),
                         SizedBox(width: 20,),
                         (snapshot.data.university != null) ? Container(
                             height: 60,
                             width: 200,
                             decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(40),
                               boxShadow: [
                                 BoxShadow(
                                   color: Colors.grey.withOpacity(0.5),
                                   spreadRadius: 5,
                                   blurRadius: 7,
                                   offset: Offset(0, 3), // changes position of shadow
                                 ),
                               ],
                             ),
                             child: snapshot.data.university != null
                                 ? Center(child: Text("Studied at - ${snapshot.data.university}",style: TextStyle(color: Colors.lightBlueAccent),))
                                 : Center(child: Text("Not set yet!",style: TextStyle(color: Colors.lightBlueAccent))))
                             : SizedBox(height: 0,) ,
                       ],
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(top: 10,left: 95),
                     child: Row(
                       children: [
                         SizedBox(width: 20,),
                         (snapshot.data.highschool != null) ? Container(
                             height: 60,
                             width: 200,
                             decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(40),
                               boxShadow: [
                                 BoxShadow(
                                   color: Colors.grey.withOpacity(0.5),
                                   spreadRadius: 5,
                                   blurRadius: 7,
                                   offset: Offset(0, 3), // changes position of shadow
                                 ),
                               ],
                             ),
                             child: snapshot.data.highschool != null
                                 ? Center(child: Text("${snapshot.data.highschool}",style: TextStyle(color: Colors.lightBlueAccent),))
                                 : Center(child: Text("Not set yet!",style: TextStyle(color: Colors.lightBlueAccent))))
                             : SizedBox(height: 0,),
                       ],
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(top: 10,left: 95),
                     child: Row(
                       children: [
                         SizedBox(width: 20,),
                         (snapshot.data.school != null) ? Container(
                             height: 60,
                             width: 200,
                             decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(40),
                               boxShadow: [
                                 BoxShadow(
                                   color: Colors.grey.withOpacity(0.5),
                                   spreadRadius: 5,
                                   blurRadius: 7,
                                   offset: Offset(0, 3), // changes position of shadow
                                 ),
                               ],
                             ),
                             child: snapshot.data.school != null
                                 ? Center(child: Text("Studied at :${snapshot.data.school}",style: TextStyle(color: Colors.lightBlueAccent),))
                                 : Center(child: Text("Not set yet!",style: TextStyle(color: Colors.lightBlueAccent))))
                             : SizedBox(height: 0,),
                       ],
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(top: 20,left: 40),
                     child: Row(
                       children: [
                         (snapshot.data.gender != null) ? Container(
                             height: 60,
                             width: 60,
                             decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(30),
                               boxShadow: [
                                 BoxShadow(
                                   color: Colors.grey.withOpacity(0.5),
                                   spreadRadius: 5,
                                   blurRadius: 7,
                                   offset: Offset(0, 3), // changes position of shadow
                                 ),
                               ],
                             ),
                             child: Icon(Icons.person,size: 30,color: Colors.lightBlueAccent,)) : SizedBox(
                           height: 0,
                         ),
                         SizedBox(width: 20,),
                         (snapshot.data.gender != null) ? Container(
                             height: 60,
                             width: 200,
                             decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(40),
                               boxShadow: [
                                 BoxShadow(
                                   color: Colors.grey.withOpacity(0.5),
                                   spreadRadius: 5,
                                   blurRadius: 7,
                                   offset: Offset(0, 3), // changes position of shadow
                                 ),
                               ],
                             ),
                             child: snapshot.data.gender != null
                                 ? Center(child: Text("Gender -${snapshot.data.gender}",style: TextStyle(color: Colors.lightBlueAccent),))
                                 : Center(child: Text("Not set yet!",style: TextStyle(color: Colors.lightBlueAccent)))): SizedBox(
          height: 0,
          ),
                       ],
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(top: 20,left: 40,bottom: 20),
                     child: Row(
                       children: [
                         (snapshot.data.homeTowen != null) ? Container(
                             height: 60,
                             width: 60,
                             decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(30),
                               boxShadow: [
                                 BoxShadow(
                                   color: Colors.grey.withOpacity(0.5),
                                   spreadRadius: 5,
                                   blurRadius: 7,
                                   offset: Offset(0, 3), // changes position of shadow
                                 ),
                               ],
                             ),
                             child: Icon(Icons.home,size: 30,color: Colors.lightBlueAccent,)) : SizedBox(height: 0,),
                         SizedBox(width: 20,),
                         (snapshot.data.homeTowen != null) ? Container(
                             height: 60,
                             width: 200,
                             decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(40),
                               boxShadow: [
                                 BoxShadow(
                                   color: Colors.grey.withOpacity(0.5),
                                   spreadRadius: 5,
                                   blurRadius: 7,
                                   offset: Offset(0, 3), // changes position of shadow
                                 ),
                               ],
                             ),
                             child: snapshot.data.homeTowen != null
                                 ? Center(child: Text("Home Towen -${snapshot.data.homeTowen}",style: TextStyle(color: Colors.lightBlueAccent),))
                                 : Center(child: Text("Not set yet!",style: TextStyle(color: Colors.lightBlueAccent))))
                             : SizedBox(height: 0,),
                       ],
                     ),
                   ),
                 ],
               )*/
                ],
              );
            }
            if(snapshot.hasError){
              return Center(child: Text('Faild To fetch Data'),);
            }
            return Center(child: CircularProgressIndicator());
          }
      ),
    );
  }
}
