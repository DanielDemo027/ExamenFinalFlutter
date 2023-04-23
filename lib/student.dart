import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyectofinal/user/productos/detail.dart';
import 'package:proyectofinal/user/productos/productos.dart';
import 'package:proyectofinal/user/ventas/viewVentas.dart';

import 'login.dart';
import 'user/productos/editnote.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Student());
}

class Student extends StatefulWidget {
  const Student({super.key});

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  final Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance.collection('productos').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 233, 232, 232),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context){
            return IconButton(
              icon: const Icon(Icons.menu),
              color: Colors.black,
              iconSize: 30,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
            
          },
        ),
        backgroundColor: Color.fromARGB(255, 233, 232, 232),
        shadowColor: Colors.black,
        elevation: 0,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 238, 62, 49),
              ),
              child: Center(
                child: Text(
                  'Bienvenido',
                  style: GoogleFonts.fragmentMono(
                    textStyle: const TextStyle(
                      fontSize: 30
                    )
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.view_list
              ),
              title: Text('Ver productos', style: GoogleFonts.fragmentMono(),),
              subtitle: Text('Aqui podras subir, consultar, editar y eliminar tus productos', style: GoogleFonts.fragmentMono()),
              onTap: (){
                Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Productos(),
                          ),
                        );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.view_list
              ),
              title: Text('Ver Ventas', style: GoogleFonts.fragmentMono()),
              subtitle: Text('Aqui podras subir, consultar, editar y eliminar tus ventas', style: GoogleFonts.fragmentMono()),
              onTap: (){
                Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Ventas(),
                          ),
                        );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout_outlined
              ),
              title: Text('Salir', style: GoogleFonts.fragmentMono()),
              onTap: () {
                logout(context);
              },
            )
          ],
        ),
      ),
      body: StreamBuilder(
        stream: _userStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasError){
            return const Text('Algo nada mal, vuelva pronto');
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            padding: const EdgeInsets.all(20),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index){
                return GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Detail(docid: snapshot.data!.docs[index])//docid: snapshot.data!.docs[index])
                      )
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 0),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(width: 2, color: Colors.black))
                        ),
                        child: ListTile(
                          title: Text(
                            snapshot.data!.docChanges[index].doc['nombre'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Column(
                            children: [
                              Image.network(snapshot.data!.docChanges[index].doc['image'], height: 200,),
                              Text(
                                'Marca:'+ snapshot.data!.docChanges[index].doc['marca'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Precio: '+snapshot.data!.docChanges[index].doc['precio'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          //leading: Image.network(snapshot.data!.docChanges[index].doc['image'], height: 500,),
                          //contentPadding: const EdgeInsets.all(15),

                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        }
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}