import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<File> imageFile;
  File _image;
  String result = '';

  doImageLabeling() async {
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(_image);
    final TextRecognizer labeler = FirebaseVision.instance.textRecognizer();
    VisionText visionText = await labeler.processImage(visionImage);
    result = "";
    setState(() {
      for (TextBlock block in visionText.blocks) {
        final Rect boundingBox = block.boundingBox;
        final String text = block.text;
        final List<RecognizedLanguage> languages = block.recognizedLanguages;

        for (TextLine line in block.lines) {
          // Same getters as TextBlock
          for (TextElement element in line.elements) {
            // Same getters as TextBlock
            result += element.text + " ";
          }
        }
        result += "\n\n";
      }
    });
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
      if (_image != null) {
        doImageLabeling();
      }
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = image;
      if (_image != null) {
        doImageLabeling();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/bg2.jpg'), fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              SizedBox(
                width: 100,
              ),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/notebook.png'),
                      fit: BoxFit.cover),
                ),
                height: 280,
                width: 250,
                margin: EdgeInsets.only(top: 70),
                padding: EdgeInsets.only(left: 28, bottom: 5, right: 18),
                child: SingleChildScrollView(
                    child: Text(
                  '$result',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'solway', fontSize: 20),
                )),
              ),

              Container(
                margin: EdgeInsets.only(top: 20, right: 140),
                child: Stack(children: <Widget>[
                  Stack(children: <Widget>[
                    Center(
                      child: Image.asset(
                        'images/clipboard.png',
                        height: 240,
                        width: 240,
                      ),
                    ),
                  ]),
                  Center(
                    child: FlatButton(
                      onPressed: _imgFromGallery,
                      onLongPress: _imgFromCamera,
                      child: Container(
                        margin: EdgeInsets.only(top: 25),
                        child: _image != null
                            ? Image.file(
                                _image,
                                width: 140,
                                height: 192,
                                fit: BoxFit.fill,
                              )
                            : Container(
                                width: 140,
                                height: 150,
                                child: Icon(
                                  Icons.find_in_page,
                                  color: Colors.grey[800],
                                ),
                              ),
                      ),
                    ),
                  ),
                ]),
              ),
              // Container(margin:EdgeInsets.only(top:300,right: 80),child: Center(
              //
              // )),
            ],
          ),
        ),
      ),
    );
  }
}
