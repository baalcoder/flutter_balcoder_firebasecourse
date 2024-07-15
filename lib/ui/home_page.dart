import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controllerEmail = new TextEditingController();
  TextEditingController _controllerPassword = new TextEditingController();

  TextEditingController _controllerName = new TextEditingController();

  late User? currentUser;
  late dynamic dataUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _isLogin();
  }

  _isLogin() {
    currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .snapshots()
          .listen((value) {
        if (value.exists) {
          dataUser = value.data();

          _controllerName.text = dataUser['name'];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentUser != null ? " Inicio" : 'Login Form'),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(children: [
            if (currentUser == null)
              TextFormField(
                controller: _controllerEmail,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    filled: true,
                    hintText: 'Ingrese su correo electrónico',
                    labelText: 'Correo electrónico'),
              ),
            SizedBox(
              height: 12,
            ),
            if (currentUser != null)
              TextFormField(
                controller: _controllerName,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    filled: true,
                    labelText: 'Nombre',
                    hintText: 'Ingrese su nombre'),
              ),
            if (currentUser == null)
              TextFormField(
                controller: _controllerPassword,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    filled: true,
                    labelText: 'Contraseña',
                    hintText: 'Ingrese su contraseña'),
              ),
            SizedBox(
              height: 32,
            ),
            Row(
              children: [
                Spacer(),
                InkWell(
                  onTap: () async {
                    if (currentUser != null) {
                      print(currentUser!.uid);
                      // GUARDAR

                      try {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(currentUser!.uid)
                            .set({'name': _controllerName.text}).then((value) {
                          print('SE GUARDO EL NOMBRE');
                        });
                      } catch (e) {
                        print(e);
                      }
                    } else {
                      _testAuth();
                    }
                  },
                  child: Container(
                    height: 48,
                    width: 180,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black)),
                    child: Center(
                        child:
                            Text(currentUser != null ? "Guardar" : 'Ingresar')),
                  ),
                ),
                Spacer()
              ],
            ),
            if (currentUser != null) Spacer(),
            if (currentUser != null)
              Row(
                children: [
                  Spacer(),
                  InkWell(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      setState(() {
                        currentUser = null;
                      });
                    },
                    child: Container(
                      height: 48,
                      width: 180,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black)),
                      child: Center(child: Text("Salir")),
                    ),
                  ),
                  Spacer()
                ],
              )
          ]),
        ),
      ),
    );
  }

  _testAuth() async {
    if (_controllerEmail.text.isNotEmpty &&
        _controllerPassword.text.isNotEmpty) {
      try {
        //REGISTRAR
        // await FirebaseAuth.instance
        //     .createUserWithEmailAndPassword(
        //         email: _controllerEmail.text,
        //         password: _controllerPassword.text)
        //     .then((value) async {
        //   if (value.user != null) {
        //     setState(() {
        //       currentUser = value.user;
        //     });
        //     print(value.user!.uid);

        //     try {
        //       await FirebaseFirestore.instance
        //           .collection('users')
        //           .doc(currentUser!.uid)
        //           .set({'uid': currentUser!.uid}).then((value) {
        //         print('SE GUARDO CON EL NOMBRE VACIO');
        //       });
        //     } catch (e) {
        //       print(e);
        //     }
        //   }
        // });

        //INGRESAR
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _controllerEmail.text,
                password: _controllerPassword.text)
            .then((value) {
          if (value.user != null) {
            setState(() {
              currentUser = value.user;
            });
            print(value.user!.uid);
          } else {
            print('No existe este usuario');
          }
        });
      } catch (e) {
        print(e);
      }
    } else {
      print('ERROR');
    }
  }
}
