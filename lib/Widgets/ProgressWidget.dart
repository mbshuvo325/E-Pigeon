import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12),
    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.lightBlueAccent),),
  );
}

linearProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12),
    child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.lightGreenAccent),),
  );
}

SpinKitProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12),
    child: SpinKitWave(color: Colors.lightBlueAccent,),
  );
}



