import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Actividad 3.7 Integración de base de datos ',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List personajes = [];

  //***Aquí hacemos el llamado a la función http */
  @override
  void initState() {
    super.initState();
    cargarPersonajes();
  }

  //*** Aquí ya hacemos el llamado http a la API de rick and morty */
  Future<void> cargarPersonajes() async {
    var url = Uri.parse('https://rickandmortyapi.com/api/character');
    var respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      var datos = jsonDecode(respuesta.body);
      setState(() {
        personajes = datos['results'];
      });
    }
  }

  //*** La interfaz donde visualizaremos los datos */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty WikiApp'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: personajes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: personajes.length,
              itemBuilder: (context, index) {
                var p = personajes[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(p['image']),
                  ),
                  title: Text(p['name']),
                  subtitle: Text('${p['species']} - ${p['status']}'),
                );
              },
            ),
    );
  }
}
