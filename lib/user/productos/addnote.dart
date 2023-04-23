import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:proyectofinal/user/productos/productos.dart';

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final TextEditingController _controllerNombre = TextEditingController();
  final TextEditingController _controllerMarca = TextEditingController();
  final TextEditingController _controllerPrecio = TextEditingController();
  final TextEditingController _controllerEstado = TextEditingController();
  final TextEditingController _controllerTalla = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();

  CollectionReference _reference =
      FirebaseFirestore.instance.collection('productos');

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 232, 232),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 233, 232, 232),
        elevation: 0,
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Home()));
            },
            child: const Text(
              'Atras',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: key,
          child: ListView(
            children: [
              TextFormField(
                controller: _controllerNombre,
                maxLines: 2,
                decoration: const InputDecoration(
                  label: Text('Nombre'),
                labelStyle: TextStyle(color: Color.fromARGB(255, 238, 62, 49)),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduzca el nombre de la prenda';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _controllerMarca,
                decoration: const InputDecoration(
                  label: Text('Marca'),
                labelStyle: TextStyle(color: Color.fromARGB(255, 238, 62, 49)),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduzca la marca de la prenda';
                  }

                  return null;
                },
              ),

              TextFormField(
                controller: _controllerPrecio,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text('Precio'),
                labelStyle: TextStyle(color: Color.fromARGB(255, 238, 62, 49)),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduzca el precio de la prenda';
                  }

                  return null;
                },
              ),

              TextFormField(
                controller: _controllerEstado,
                decoration: const InputDecoration(
                  label: Text('Estado'),
                  labelStyle: TextStyle(color: Color.fromARGB(255, 238, 62, 49)),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Introdusca el estado de la prenda';
                  }

                  return null;
                },
              ),

              TextFormField(
                controller: _controllerTalla,
                decoration: const InputDecoration(
                  label: Text('Talla'),
                  labelStyle: TextStyle(color: Color.fromARGB(255, 238, 62, 49)),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduzca la talla de la prenda';
                  }

                  return null;
                },
              ),

              SizedBox(
                height: 30,
              ),

              const Text('Subir imagen'),
              IconButton(
                  onPressed: () async {
                    /*
                * Step 1. Pick/Capture an image   (image_picker)
                * Step 2. Upload the image to Firebase storage
                * Step 3. Get the URL of the uploaded image
                * Step 4. Store the image URL inside the corresponding
                *         document of the database.
                * Step 5. Display the image on the list
                *
                * */

                    /*Step 1:Pick image*/
                    //Install image_picker
                    //Import the corresponding library

                    ImagePicker imagePicker = ImagePicker();
                    XFile? file =
                        await imagePicker.pickImage(source: ImageSource.camera);
                    print('${file?.path}');

                    if (file == null) return;
                    //Import dart:core
                    String uniqueFileName =
                        DateTime.now().millisecondsSinceEpoch.toString();

                    /*Step 2: Upload to Firebase storage*/
                    //Install firebase_storage
                    //Import the library

                    //Get a reference to storage root
                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages =
                        referenceRoot.child('images');

                    //Create a reference for the image to be stored
                    Reference referenceImageToUpload =
                        referenceDirImages.child(uniqueFileName);

                    //Handle errors/success
                    try {
                      //Store the file
                      await referenceImageToUpload.putFile(File(file!.path));
                      //Success: get the download URL
                      imageUrl = await referenceImageToUpload.getDownloadURL();
                    } catch (error) {
                      //Some error occurred
                    }
                  },
                  icon: const Icon(Icons.camera_alt)),
              ElevatedButton(
                  onPressed: () async {
                    if (imageUrl.isEmpty) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('Seleccione una imagen')));

                      return;
                    }

                    if (key.currentState!.validate()) {
                      String nombre = _controllerNombre.text;
                      String marca = _controllerMarca.text;
                      String precio = _controllerPrecio.text;
                      String estado = _controllerEstado.text;
                      String talla = _controllerTalla.text;

                      //Create a Map of data
                      Map<String, String> dataToSend = {
                        'nombre': nombre,
                        'marca': marca,
                        'precio': precio,
                        'estado': estado,
                        'talla': talla,
                        'image': imageUrl,
                      };

                      //Add a new item
                      _reference.add(dataToSend);

                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Home()));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 238, 62, 49)
                  ),
                  child: const Text('Guardar')
                  )
            ],
          ),
        ),
      ),
    );
  }
}