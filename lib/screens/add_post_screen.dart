import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fasum/screens/home_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _controllerDesc = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  await _showImageSourceDialog();
                },
                child: Container(
                  child: _image != null
                      ? Image.file(File(_image!.path))
                      : Image.asset('assets/images/add_photo.png'),
                  ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _controllerDesc,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Description',

                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    //fontWeight: FontWeight.bold
                  ),
                ),
                onPressed: () async {
                  if (_image == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select an image')),
                    );
                    return;
                  }

                  Reference referenceRoot = FirebaseStorage.instance.ref();
                  Reference referenceDirImages = referenceRoot.child("images");
                  Reference referenceImagesToUpload =
                  referenceDirImages.child(_image!.path.split("/").last);

                  try {
                    final uploadTask =
                    await referenceImagesToUpload.putFile(File(_image!.path));
                    final downloadUrl = await uploadTask.ref.getDownloadURL();

                    // Add Firebase Cloud Firestore functionality here
                    final CollectionReference posts =
                    FirebaseFirestore.instance.collection('add_post');
                    await posts.add({
                      'desc': _controllerDesc.text,
                      'url': downloadUrl,
                      'time': Timestamp.now(),
                      'email': _auth.currentUser?.email,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Post Added! :D')),
                    );

                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error when uploading the image: $e')),
                    );
                  }
                },
                child: Text('Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showImageSourceDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Open Camera'),
              onTap: () async {
                Navigator.of(context).pop();
                final pickedFile =
                await _picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  setState(() {
                    _image = pickedFile;
                  });
                }
              },
            ),
            ListTile(
              title: Text('Pick from Gallery'),
              onTap: () async {
                Navigator.of(context).pop();
                final pickedFile =
                await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    _image = pickedFile;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllerDesc.dispose();
    super.dispose();
  }
}