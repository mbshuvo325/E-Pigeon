import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullPhoto extends StatelessWidget {

  final String url;

  FullPhoto({Key key, @required this.url}): super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('View Photo',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
      ),
      body: FullPhotoScreen(photourl: url),
    );
  }
}

class FullPhotoScreen extends StatefulWidget {

  final String photourl;
  FullPhotoScreen({Key key, @required this.photourl}): super(key : key);

  @override
  State createState() => FullPhotoScreenState(url: photourl);
}

class FullPhotoScreenState extends State<FullPhotoScreen> {

  final String url;
  FullPhotoScreenState({Key key, @required this.url});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
        imageProvider: NetworkImage(url),
      ),
    );
  }
}
