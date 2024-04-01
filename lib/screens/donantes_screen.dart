import 'dart:convert';
import 'package:donantes2/screens/login_scren.dart';
import 'package:donantes2/services/serviceapi_donantes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Export {
  final int iDonante;
  final String nombreDonante;
  final String direccionDonante;
  final String telefonoDonante;
  final String emailDonante;
  final String tipoDocumento;
  final String documentoDonante;
  final String fechaRegistro;
  final String entidad;

  Export({
    required this.iDonante,
    required this.nombreDonante,
    required this.direccionDonante,
    required this.telefonoDonante,
    required this.emailDonante,
    required this.tipoDocumento,
    required this.documentoDonante,
    required this.fechaRegistro,
    required this.entidad,
  });

  factory Export.fromJson(Map<String, dynamic> json) {
    return Export(
      iDonante: json['id_Donante'],
      nombreDonante: json['nombre_Donante'],
      direccionDonante: json['direccion_Donante'],
      telefonoDonante: json['telefono_Donante'],
      emailDonante: json['email_Donante'],
      tipoDocumento: json['tipo_Donante'],
      documentoDonante: json['documento_Identidad'],
      fechaRegistro: json['fecha_Registro'],
      entidad: json['entidad_Asociada'],
    );
  }
}

Future<List<Export>> fetchPosts() async {
  final response =
      await http.get(Uri.parse('https://apidonantes.onrender.com/donantes'));

  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = json.decode(response.body);
    List<dynamic> exportList = responseData['msg'];
    List<Export> exports =
        exportList.map((json) => Export.fromJson(json)).toList();

    return exports;
  } else {
    throw Exception('Falló la carga de los donantes.');
  }
}

class DonantesScreen extends StatefulWidget {
  const DonantesScreen({super.key});

  @override
  State<DonantesScreen> createState() => _DonantesScreenState();
}

class _DonantesScreenState extends State<DonantesScreen> {
  late Future<List<Export>> futureExports;

  @override
  void initState() {
    super.initState();
    futureExports = fetchPosts();
  }

  void redirigir() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Está seguro que desea cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('Cerrar Sesión'),
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
            child: Text('Lista de donantes',
                style: TextStyle(fontWeight: FontWeight.bold))),
        backgroundColor: const Color.fromARGB(255, 245, 149, 108),
        actions: [
          IconButton(
            onPressed: () {
              redirigir();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
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
            child: SizedBox(
              height: 600,
              width: 400,
              child: FutureBuilder<List<Export>>(
                future: futureExports,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Export> exports = snapshot.data!;
                    return ListView.builder(
                      itemCount: exports.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 245, 149, 108)),
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white.withOpacity(0.6),
                          ),
                          margin: EdgeInsets.all(8.0),
                          padding: EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Registrar(export: exports[index]),
                                ),
                              ).then((value) {
                                setState(() {
                                  futureExports =
                                      fetchPosts(); // Reload data after editing
                                });
                              });
                            },
                            onLongPress: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Eliminar donante'),
                                content: const Text(
                                    '¿Está seguro que desea eliminar este donante?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancelar'),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      final response = await ServiceAPI().delete(
                                          'donantes/${exports[index].iDonante}');
                                      Navigator.pop(context, 'Eliminar');
                                      if (response.statusCode == 200) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Donante eliminado'),
                                          ),
                                        );
                                        setState(() {
                                          futureExports =
                                              fetchPosts(); // Reload data after deletion
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Error al eliminar'),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text('Eliminar'),
                                  ),
                                ],
                              ),
                            ),
                            title: Text(exports[index].nombreDonante,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text("Teléfono: " +
                                exports[index].telefonoDonante +
                                "\nCorreo Electrónico: " +
                                exports[index].emailDonante),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Color.fromARGB(255, 245, 149, 108),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Registrar()),
          ).then((value) {
            setState(() {
              futureExports = fetchPosts(); // Reload data after adding
            });
          });
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 245, 149, 108),
      ),
      backgroundColor: const Color.fromARGB(255, 239, 233, 230),
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

class Registrar extends StatefulWidget {
  final Export? export;

  const Registrar({Key? key, this.export}) : super(key: key);

  @override
  State<Registrar> createState() => RegistrarState();
}

class RegistrarState extends State<Registrar> {
  TextEditingController idDonante = TextEditingController();
  TextEditingController nombreDonante = TextEditingController();
  TextEditingController direccionDonante = TextEditingController();
  TextEditingController telefonoDonante = TextEditingController();
  TextEditingController emailDonante = TextEditingController();
  TextEditingController tipoDocumento = TextEditingController();
  TextEditingController documentoDonante = TextEditingController();
  TextEditingController fechaRegistro = TextEditingController();
  TextEditingController entidadAsociada = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Asignar la fecha actual al campo de texto al inicializar el estado
    fechaRegistro.text =
        DateTime.now().toString(); // Esto asignará la fecha en formato de texto
  }

  @override
  Widget build(BuildContext context) {
    if (widget.export != null) {
      idDonante.text = widget.export!.iDonante.toString();
      nombreDonante.text = widget.export!.nombreDonante;
      direccionDonante.text = widget.export!.direccionDonante;
      telefonoDonante.text = widget.export!.telefonoDonante;
      emailDonante.text = widget.export!.emailDonante;
      tipoDocumento.text = widget.export!.tipoDocumento;
      documentoDonante.text = widget.export!.documentoDonante;
      fechaRegistro.text = widget.export!.fechaRegistro;
      entidadAsociada.text = widget.export!.entidad;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.export != null ? 'Editar donante' : 'Registrar donante'),
        backgroundColor: const Color.fromARGB(255, 245, 149, 108),
      ),
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              "assets/images/fondo.jpg", // Ruta de la imagen de fondo
              fit: BoxFit.cover, // Ajusta la imagen para cubrir todo el contenedor
            ),
          ),
          // Contenido de la pantalla de registro
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Container(
                  color: Colors.white.withOpacity(0.6),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          controller: idDonante,
                          decoration: const InputDecoration(labelText: 'Id donante'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese el id del donante';
                            }
                            return null;
                          },
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: nombreDonante,
                        decoration: const InputDecoration(
                            labelText: 'Nombre del donante'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el nombre del donante';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: direccionDonante,
                        decoration:
                            const InputDecoration(labelText: 'Dirección'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese la dirección del donante';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        controller: telefonoDonante,
                        decoration:
                            const InputDecoration(labelText: 'Teléfono'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el teléfono del donante';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: emailDonante,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el email del donante';
                          }
                          // Expresión regular para validar emails
                          final emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          );
                          if (!emailRegex.hasMatch(value)) {
                            return 'Por favor ingrese un email válido';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tipoDocumento,
                        decoration: const InputDecoration(
                            labelText: 'Tipo de documento'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el tipo de documento';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        controller: documentoDonante,
                        decoration: const InputDecoration(
                            labelText: 'Documento de identidad'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el documento del donante';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: fechaRegistro,
                        enabled: false,
                        decoration: const InputDecoration(
                            labelText: 'Fecha de registro'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese la fecha de registro';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: entidadAsociada,
                        decoration: const InputDecoration(
                            labelText: 'Entidad asociada'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese la entidad asociada';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (widget.export == null)
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            var export = {
                              "id_Donante": int.parse(idDonante.text),
                              "nombre_Donante": nombreDonante.text,
                              "direccion_Donante": direccionDonante.text,
                              "telefono_Donante": telefonoDonante.text,
                              "email_Donante": emailDonante.text,
                              "tipo_Donante": tipoDocumento.text,
                              "documento_Identidad": documentoDonante.text,
                              "fecha_Registro": fechaRegistro.text,
                              "entidad_Asociada": entidadAsociada.text,
                            };
                            ServiceAPI api = ServiceAPI();
                            final response = await api.post('donantes', export);
                            if (response.statusCode == 200) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Donante registrado exitosamente')),
                              );
                              Navigator.pop(
                                  context); // Close the dialog after adding
                            } else {
                              print('Error al registrar el donante');
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 245, 149, 108),
                          onPrimary: Colors.black,
                          side: BorderSide(color: Colors.black),
                        ),
                        child: const Text('Registrar'),
                      ),
                    if (widget.export != null)
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            var updatedExport = {
                              "id_Donante": int.parse(idDonante.text),
                              "nombre_Donante": nombreDonante.text,
                              "direccion_Donante": direccionDonante.text,
                              "telefono_Donante": telefonoDonante.text,
                              "email_Donante": emailDonante.text,
                              "tipo_Donante": tipoDocumento.text,
                              "documento_Identidad": documentoDonante.text,
                              "fecha_Registro": fechaRegistro.text,
                              "entidad_Asociada": entidadAsociada.text,
                            };
                            ServiceAPI api = ServiceAPI();
                            final response = await api.put(
                                'donantes/${widget.export!.iDonante}',
                                updatedExport);
                            if (response.statusCode == 200) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Donante actualizado')),
                              );
                              Navigator.pop(
                                  context); // Close the dialog after updating
                            } else {
                              print('Error al actualizar el donante');
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 245, 149, 108),
                          onPrimary: Colors.black,
                          side: BorderSide(color: Colors.black),
                        ),
                        child: const Text('Actualizar'),
                      ),
                  ],
                ),
              ),
            ),
          ),
          )
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

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => const DonantesScreen(),
      '/registrar': (context) => const Registrar(),
    },
  ));
}
