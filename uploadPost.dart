import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/constans/Constantcolors.dart';
import 'package:chat_app/services/Authentication.dart';
import 'package:chat_app/services/FirebaseOperations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/screens/landingpage/landinUtils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadPost with ChangeNotifier {
  TextEditingController captionController = TextEditingController();
  ConstantColors constantColor = ConstantColors();
  late File uploadPostImage;
  File get getuploadPostImage => uploadPostImage;
  late String uploadPostImageUrl;
  String get getuploadPostImageUrl => uploadPostImageUrl;
  final picker = ImagePicker();
  late UploadTask imagePostUploadTask;

  Future pickUploadPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageVal = await picker.getImage(source: source);
    uploadPostImageVal == null
        ? print('select image')
        : this.uploadPostImage = File(uploadPostImageVal.path);

    uploadPostImage != null
        ? showPostImageType(context)
        : print('Image upload error');
    notifyListeners();
  }

  selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColor.whiteColor,
                borderRadius: BorderRadius.circular(14)),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 5.0,
                      color: Colors.green.shade900,
                    )),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                        elevation: 10.0,
                        focusElevation: 20.0,
                        hoverElevation: 20.0,
                        backgroundColor: Colors.blue,
                        onPressed: () {
                          pickUploadPostImage(context, ImageSource.gallery);
                        },
                        child: Icon(
                          Icons.photo,
                          color: Colors.white,
                        )),
                    FloatingActionButton(
                      backgroundColor: Colors.red,
                      onPressed: () {
                        pickUploadPostImage(context, ImageSource.camera);
                      },
                      child: Icon(FontAwesomeIcons.camera, color: Colors.white),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  showPostImageType(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColor.whiteColor,
                borderRadius: BorderRadius.circular(14)),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 5.0,
                      color: Colors.green.shade900,
                    )),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: RichText(
                      text: TextSpan(
                          text: 'confirm ',
                          style: TextStyle(
                            fontSize: 40.0,
                            color: constantColor.darkColor,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                          children: <TextSpan>[
                        TextSpan(
                          text: ' image ',
                          style: TextStyle(
                            fontSize: 35.0,
                            color: Colors.green,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ])),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: Container(
                    height: 200,
                    width: 400,
                    child: Image.file(uploadPostImage, fit: BoxFit.contain),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                          elevation: 10.0,
                          focusElevation: 20.0,
                          hoverElevation: 20.0,
                          backgroundColor: Colors.blue,
                          onPressed: () {
                            uploadPostImageToFirebase().whenComplete(() {
                              editPostSheet(context);
                              print("image uploaded");
                            });
                          },
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          )),
                      FloatingActionButton(
                        backgroundColor: Colors.red,
                        onPressed: () {
                          selectPostImageType(context);
                        },
                        child: Icon(Icons.repeat, color: Colors.white),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Future uploadPostImageToFirebase() async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('posts/${uploadPostImage.path}/${TimeOfDay.now()}');
    imagePostUploadTask = imageReference.putFile(uploadPostImage);
    await imagePostUploadTask.whenComplete(() {
      print('post uploaded successfully');
    });
    imageReference.getDownloadURL().then((imageUrl) {
      uploadPostImageUrl = imageUrl;
      print(uploadPostImageUrl);
      notifyListeners();
    });
  }

  editPostSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 150.0),
                      child: Divider(
                        thickness: 5.0,
                        color: Colors.green.shade900,
                      )),
                  Container(
                      child: Row(
                    children: [
                      Container(
                          child: Column(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.fit_screen_rounded,
                                color: constantColor.yellowColor),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.image_aspect_ratio,
                                color: Colors.blue),
                          )
                        ],
                      )),
                      Container(
                        height: 200,
                        width: 300,
                        child: Image.file(uploadPostImage, fit: BoxFit.contain),
                      )
                    ],
                  )),
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: Image.asset(
                                'assets/images/nigerianFlag-removebg-preview.png'),
                          ),
                          Container(
                              height: 110,
                              width: 5,
                              color: Colors.green.shade500),
                          Container(
                            height: 120,
                            width: 330,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextField(
                                maxLines: 5,
                                autocorrect: true,
                                textCapitalization: TextCapitalization.words,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(100)
                                ],
                                enableSuggestions: true,
                                maxLength: 100,
                                controller: captionController,
                                style: TextStyle(
                                  color: constantColor.darkColor,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'add a caption...',
                                  hintStyle: TextStyle(
                                    color: constantColor.blueGreyColor,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ]),
                  ),
                  MaterialButton(
                      color: constantColor.greenColor,
                      onPressed: () async {
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .uploadPostData(captionController.text, {
                          'caption': captionController.text,
                          'postimage': getuploadPostImageUrl,
                          'username': Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .getinitUserName,
                          'userimage': Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .getinitUserImage,
                          'useruid': Provider.of<Authentication>(context,
                                  listen: false)
                              .getUserUid,
                          'time': Timestamp.now(),
                          'useremail': Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .getinitUserEmail,
                        }).whenComplete(() {
                          Navigator.pop(context);
                        });
                      },
                      child: Text('post',
                          style: TextStyle(
                              fontSize: 14, color: constantColor.whiteColor)))
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColor.whiteColor,
                borderRadius: BorderRadius.circular(14),
              ));
        });
  }
}
