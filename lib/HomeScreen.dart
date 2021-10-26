import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _scanning = false;
  String _extractText = '';
  File _pickedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red[800],
        title: Text('Textract - Text Extractor for images',
          style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        ),
      ),
      body: ListView(
        children: [
          _pickedImage == null
              ? Container(
            height: 300,
            color: Colors.grey[300],
            child: Icon(
              Icons.image,
              size: 100,
            ),
          )
              : Container(
            height: 300,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                image: DecorationImage(
                  image: FileImage(_pickedImage),
                  fit: BoxFit.fill,
                )),
          ),
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: RaisedButton(
              color: Colors.red[800],
              child: Text(
                'Take photo from Camera',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                setState(() {
                  _scanning = true;
                });
                _pickedImage =
                await ImagePicker.pickImage(source: ImageSource.camera);
                _extractText =
                await TesseractOcr.extractText(_pickedImage.path);
                setState(() {
                  _scanning = false;
                });
              },
            ),
          ),
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: RaisedButton(
              color: Colors.red[800],
              child: Text(
                'Upload Image from Gallery',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                setState(() {
                  _scanning = true;
                });
                _pickedImage =
                await ImagePicker.pickImage(source: ImageSource.gallery);
                _extractText =
                await TesseractOcr.extractText(_pickedImage.path);
                setState(() {
                  _scanning = false;
                });
              },
            ),
          ),
          SizedBox(height: 20),
          _scanning
              ? Center(child: CircularProgressIndicator())
              : _extractText == '' ? Icon(
            Icons.add_to_photos_outlined,
            size: 40,
            color: Colors.black) :
              Icon(
              Icons.done,
              size: 40,
              color: Colors.green,
          ),
          SizedBox(height: 20),
          Center(child: Column(children: [
            Text(
              _extractText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            _extractText != '' ? Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: RaisedButton(
                child: Text('Copy Text to Clipboard', style: TextStyle(fontSize: 15.0),),
                color: Colors.red[800],
                textColor: Colors.white,
                onPressed: () {Clipboard.setData(new ClipboardData(text: _extractText)); popup(context);},
              ),
            ) :
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: RaisedButton(
                child: Text('Copy Text to Clipboard', style: TextStyle(fontSize: 15.0),),
                color: Colors.red[300],
                textColor: Colors.white,
                onPressed: null,
              ),
            ),

          ])
          ),
          SizedBox(   //Use of SizedBox
            height: 30,
          ),
          /*Center(child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(children: [
              Text(
                "Want to try for ",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ".pdf ",
                style: TextStyle(
                  color: Colors.red[800],
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "files?",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
            SizedBox(width: 20),
            Container(
             // margin: EdgeInsets.all(),
              child: FlatButton(
                child: Text('Try our Desktop Version', style: TextStyle(fontSize: 15.0),),
                color: Colors.red[700],
                textColor: Colors.white,
                onPressed: _launchURL,
              ),
            ),
          ])
          ),
          SizedBox(   //Use of SizedBox
            height: 20,
          )*/
        ],
      ),
    );
  }

  _launchURL() async {
    const url = 'http://18.222.220.89:5000/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void popup(BuildContext context){

    var alertDialog = AlertDialog(
      title: Text("Text copied!",
        textAlign: TextAlign.center,
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      }
    );
  }
}