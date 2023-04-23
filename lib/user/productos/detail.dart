// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:printing/printing.dart';
import 'package:proyectofinal/student.dart';

class Detail extends StatefulWidget {
  DocumentSnapshot docid;
  Detail({required this.docid});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  String finalDate = '';
  getCurrentDate(){
 
    var date = new DateTime.now().toString();
 
    var dateParse = DateTime.parse(date);
 
    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
 
    setState(() {
 
      finalDate = formattedDate.toString() ;
 
    });
 
  }

    CollectionReference _reference = FirebaseFirestore.instance.collection('ventas');
   final Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance.collection('productos').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 232, 232),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 233, 232, 232),
        elevation: 0,
        leading: IconButton(
          onPressed: (){
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Student()));
          },
          icon: const Icon(Icons.arrow_back, size: 30, color: Colors.black,),
        ),
      ),
      body: StreamBuilder(
        stream: _userStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return const Text('Algo nada mal, vuelva pronto');
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: Center(
                        child: Image.network(snapshot.data!.docChanges[index].doc['image'], height: 350,),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.all(15),
                      child: Text(snapshot.data!.docChanges[index].doc['nombre'],
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(15),
                      child: Text('Marca: '+snapshot.data!.docChanges[index].doc['marca'],
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(15),
                      child: Text('Talla: '+snapshot.data!.docChanges[index].doc['talla'],
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                     Container(
                      margin: EdgeInsets.all(15),
                      child: Text('Estado: '+snapshot.data!.docChanges[index].doc['estado'],
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                     Container(
                      margin: EdgeInsets.all(15),
                      child: Text('Precio: '+snapshot.data!.docChanges[index].doc['precio'],
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),

                    Container(
                      child: Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 238, 62, 49),
                          ),
                          onPressed: (){
                            getCurrentDate();
                            Map<String, String> dataToSend ={
                              'nombre': snapshot.data!.docChanges[index].doc['nombre'],
                              'marca': snapshot.data!.docChanges[index].doc['marca'],
                              'precio': snapshot.data!.docChanges[index].doc['precio'],
                              'imagen': snapshot.data!.docChanges[index].doc['image'],
                              'fecha': finalDate
                            };
                            //print(dataToSend);
                            _reference.add(dataToSend);

                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Student()));
                          },
                          child: const Text('Comprar', style: TextStyle(fontSize: 15),)
                        ),
                      ),
                    ),   
                  ],
                );
              },
            )
          );
        },
      )
    );
  }
}