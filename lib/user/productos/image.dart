import 'dart:io';

import 'package:flutter/material.dart';
import 'package:proyectofinal/user/productos/services/select_image.dart';
import 'package:proyectofinal/user/productos/services/upload_image.dart';

class Imagen_UI extends StatefulWidget {
  const Imagen_UI({super.key});

  @override
  State<Imagen_UI> createState() => _Imagen_UIState();
}

class _Imagen_UIState extends State<Imagen_UI> {

  File? imagen_to_upload;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        imagen_to_upload != null ? Image.file(imagen_to_upload!) : Container(
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 10),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: Colors.white
          ),
          child: Image.network('https://i.imgur.com/sUFH1Aq.png'),
        ),

        ElevatedButton(
          onPressed: () async {
            final imagen = await getImage();
            setState(() {
              imagen_to_upload = File(imagen!.path);
            });
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 238, 62, 49)
          ),
          child: const Text('Seleccionar imagen')
        ),


        ElevatedButton(
          onPressed: () async{
            if(imagen_to_upload == null){
              return;
            }

            final uploaded = await uploadImage(imagen_to_upload!);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 238, 62, 49)
          ),
          child: const Text('Subir imagen'),
        )
      ],
    );
  }
}