import 'dart:convert';
import 'package:http/http.dart' as http;

class ServiceAPI {
  final String BASE_URL = "https://apidonantes.onrender.com/";

  Future<List<Map<String, dynamic>>> get() async {
    final response = await http.get(Uri.parse(BASE_URL));

    print(response.body); // Imprimir el cuerpo de la respuesta para verificar la estructura

    if (response.statusCode == 200) {
      // Parsear la respuesta como un JSON
      Map<String, dynamic> responseData = json.decode(response.body);

      // Acceder al arreglo de exportaciones dentro de la propiedad "msg"
      List<dynamic> exportList = responseData['msg'];

      // Mapear cada objeto del arreglo a la clase Export
      List<Map<String, dynamic>> exports =
          exportList.map((json) => json).toList().cast<Map<String, dynamic>>();

      return exports;
    } else {
      throw Exception('Falló la carga de los donantes.');
    }
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(Uri.parse(BASE_URL + endpoint),
        headers: {"Content-Type": "application/json"}, body: json.encode(data));

    try {
      if (response.statusCode == 200) {
        print("Post request successful");
      } else {
        throw Exception('Failed to post');
      }
    } catch (e) {
      print(e);
    }

    return response;
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    final response = await http.put(Uri.parse(BASE_URL + endpoint),
        headers: {"Content-Type": "application/json"}, body: json.encode(data));

    try {
      if (response.statusCode == 200) {
        print("Put request successful");
      } else {
        throw Exception('Failed to put');
      }
    } catch (e) {
      print(e);
    }

    return response;
  }

  Future<http.Response> delete(String endpoint) async {
    final response = await http.delete(Uri.parse(BASE_URL + endpoint));

    try {
      if (response.statusCode == 200) {
        print("Delete request successful");
      } else {
        throw Exception('Failed to delete');
      }
    } catch (e) {
      print(e);
    }

    return response;
  }

}
