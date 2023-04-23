import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyectofinal/user/productos/productos.dart';


class editnote extends StatefulWidget {
  DocumentSnapshot docid;
  editnote({required this.docid});

  @override
  State<editnote> createState() => _editnoteState(docid: docid);
}

class _editnoteState extends State<editnote> {
  DocumentSnapshot docid;
  _editnoteState({required this.docid});
  TextEditingController nombre = TextEditingController();
  TextEditingController marca = TextEditingController();
  TextEditingController precio = TextEditingController();
  TextEditingController estado = TextEditingController();
  TextEditingController talla = TextEditingController();

  @override
  void initState(){
    nombre = TextEditingController(text: widget.docid.get('nombre'));
    marca = TextEditingController(text: widget.docid.get('marca'));
    precio = TextEditingController(text: widget.docid.get('precio'));
    estado = TextEditingController(text: widget.docid.get('estado'));
    talla = TextEditingController(text: widget.docid.get('talla'));
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 232, 232),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 233, 232, 232),
        
        actions: [
          MaterialButton(
            padding: const EdgeInsets.only(left: 0, right: 110),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Home()));
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),

          MaterialButton(
            onPressed: () {
              widget.docid.reference.update({
                'nombre': nombre.text,
                'marca': marca.text,
                'precio': precio.text,
                'estado': estado.text,
                'talla': talla.text
              }).whenComplete((){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Home()));
              });
            },
            child: const Text(
              'Actualizar',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              widget.docid.reference.delete().whenComplete((){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Home()));
              });
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
            margin: const EdgeInsets.fromLTRB(35, 50, 35, 0),
            child: TextField(
              controller: nombre,
              maxLines: 2,
              decoration: const InputDecoration(
                label: Text('Nombre'),
                labelStyle: TextStyle(color: Color.fromARGB(255, 238, 62, 49)),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(35, 50, 35, 0),
            child: TextField(
              controller: marca,
              decoration: const InputDecoration(
                label: Text('Marca'),
                labelStyle: TextStyle(color: Color.fromARGB(255, 238, 62, 49)),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(35, 50, 35, 0),
            child: TextField(
              controller: precio,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                label: Text('Precio'),
                labelStyle: TextStyle(color: Color.fromARGB(255, 238, 62, 49)),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(35, 50, 35, 0),
            child: TextField(
              controller: estado,
              decoration: const InputDecoration(
                label: Text('Estado'),
                labelStyle: TextStyle(color: Color.fromARGB(255, 238, 62, 49)),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(35, 50, 35, 40),
            child: TextField(
              controller: talla,
              decoration: const InputDecoration(
                label: Text('Talla'),
                labelStyle: TextStyle(color: Color.fromARGB(255, 238, 62, 49)),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}