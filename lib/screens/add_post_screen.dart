import 'package:fasum/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  TextEditingController _controllerDesc = TextEditingController();
  //XFile ? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: (){
                _pickImageFromCamera();
              },
              child: Image.asset(
                'assets/images/add_photo.png',
                width: 250,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controllerDesc,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Description',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              //_productService.addProductItem(_controllerKode.text, _controllerNama.text,  _controllerDesc.text);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              textStyle: const TextStyle(
                fontSize: 18,
                //fontWeight: FontWeight.bold
              ),
            ),
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  Future _pickImageFromCamera() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.camera);
  //   if(returnedImage==null) return;
  //   setState(() {
  //     _selectedImage = XFile(returnedImage!.path);
  //   });
  }
}