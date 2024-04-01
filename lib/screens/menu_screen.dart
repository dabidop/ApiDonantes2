import 'package:donantes2/screens/donantes_screen.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "VidaKids",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 245, 149, 108),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/fondo.jpg"), // Ruta de la imagen de fondo
            fit: BoxFit.cover, // Ajusta la imagen para cubrir todo el contenedor
          ),
        ),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white.withOpacity(0.6), // Color de fondo del primer ListTile
                child: ListTile(
                  title: const Text("Donaciones", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("Toque para acceder a las donaciones"),
                  leading: const Icon(Icons.list_alt_outlined),
                  trailing: const Icon(Icons.navigate_next_outlined, color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Radio de la esquina del borde
                    side: const BorderSide(color: Color.fromARGB(255, 245, 149, 108), width: 2.0), // Color y grosor del borde
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white.withOpacity(0.6), // Color de fondo con opacidad del 60% del segundo ListTile
                child: ListTile(
                  title: const Text("Donantes", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("Toque para acceder a los donantes"),
                  leading: const Icon(Icons.person_2_outlined),
                  trailing: const Icon(Icons.navigate_next_outlined, color: Colors.black),
                  onTap: () {
                    final route = MaterialPageRoute(
                        builder: (context) => const DonantesScreen());
                    Navigator.push(context, route);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Radio de la esquina del borde
                    side: const BorderSide(color: Color.fromARGB(255, 245, 149, 108), width: 2.0), // Color y grosor del borde
                  ),
                ),
              ),
            ),
          ],
        ),

      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.grey.withOpacity(0.7),
        child: const Center(
          child: Text(
            'Autor: David Álvarez Restrepo',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

