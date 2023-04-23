import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyectofinal/login.dart';
import 'package:proyectofinal/student.dart';
import 'package:proyectofinal/user/productos/addnote.dart';
import 'package:proyectofinal/user/productos/editnote.dart';
import 'package:proyectofinal/user/productos/productos.dart';

//import 'addnote.dart';
//import 'editnote.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Ventas());
}

class Ventas extends StatefulWidget {
  const Ventas({super.key});

  @override
  State<Ventas> createState() => _VentasState();
}

class _VentasState extends State<Ventas> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
        textTheme: GoogleFonts.fragmentMonoTextTheme()
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance.collection('ventas').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 232, 232),
      appBar: AppBar(
        title: const Text('Ventas', textAlign: TextAlign.center, style: TextStyle(color: Colors.black),),
        centerTitle: true,
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
        backgroundColor: const Color.fromARGB(255, 233, 232, 232),
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
                Icons.home
              ),
              title: Text('Home', style: GoogleFonts.fragmentMono(),),
              onTap: (){
                Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Student(),
                          ),
                        );
              },
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
                              Text(
                                'Vendido: '+snapshot.data!.docChanges[index].doc['fecha'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),

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