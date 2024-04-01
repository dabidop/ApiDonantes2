import 'package:donantes2/screens/menu_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usuario = TextEditingController();
  TextEditingController contrasena = TextEditingController();
  bool mostrarContrasena = false;

  void logear() {
    if (usuario.text == 'dabidop' && contrasena.text == "12345678") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MenuScreen()),
      );
    } else if (usuario.text == "usuario" && contrasena.text == "contrasena") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MenuScreen()),
      );
    } else {
      mostrarAlertaIncorrecto();
    }
  }

  void mostrarAlertaIncorrecto() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Usuario o Contraseña Incorrectos'),
          content: const Text(
              'Por favor, revise su nombre de usuario y contraseña e intente nuevamente.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra la alerta
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          "assets/images/VidaKidsLogoNoFondo.png",
          width: 40,
          height: 40,
        ),
        title: const Center(
          child: Text(
            "Inicio de sesión",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 245, 149, 108),
      ),
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              "assets/images/fondo.jpg", // Ruta de la imagen de fondo
              fit: BoxFit
                  .cover, // Ajusta la imagen para cubrir todo el contenedor
            ),
          ),
          // Contenido de la pantalla de inicio de sesión
          Center(
            child: Container(
              width: 300,
              height: 450,
              color: Colors.white.withOpacity(0.6),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        15), // Puedes ajustar el radio según tus necesidades
                    child: SizedBox(
                      width: 100, // Ancho deseado del contenedor
                      height: 100, // Alto deseado del contenedor
                      child: Image.asset(
                        "assets/images/VidaKidsLogoNoFondo.png",
                        fit: BoxFit
                            .cover, // Ajusta la imagen para cubrir todo el contenedor
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: usuario,
                      decoration: const InputDecoration(labelText: 'Usuario'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: contrasena,
                      obscureText:
                          !mostrarContrasena, // Mostrar asteriscos si es false
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        suffixIcon: IconButton(
                          icon: Icon(mostrarContrasena
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              mostrarContrasena =
                                  !mostrarContrasena; // Alternar entre mostrar y ocultar contraseña
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      logear();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color.fromARGB(255, 245, 149, 108),
                      side: const BorderSide(color: Colors.black),
                    ),
                    child: const Text('Iniciar sesión'),
                  ),
                ],
              ),
            ),
          ),
        ],
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
