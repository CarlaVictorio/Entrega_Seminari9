import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateArticuloPage extends StatefulWidget {
  @override
  _CreateArticuloPageState createState() => _CreateArticuloPageState();
}

class _CreateArticuloPageState extends State<CreateArticuloPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _name;
  String? _description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Crear Articulo',
          style: TextStyle(
            color: Color(0xFFFFFCEA),
          ),
        ),
        backgroundColor: Color(0xFF486D28),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    color: Color(0xFF486D28),
                  ),
                ),
                onSaved: (value) => _name = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(
                    color: Color(0xFF486D28),
                  ),
                ),
                onSaved: (value) => _description = value,
              ),
              SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          final Map<String, String> articuloData = {
                            'name': _name ?? "",
                            'description': _description ?? "",
                          };

                          final response = await http.post(
                            Uri.parse(
                                'http://localhost:9090/articulos/createarticulo/'),
                            body: articuloData,
                          );

                          if (response.statusCode == 201) {
                            print('Articulo creado con éxito.');

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Éxito'),
                                  content: Text('Articulo creado con éxito'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Aceptar'),
                                      onPressed: () {
                                        // Cierra el diálogo
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            print(
                                'Error al crear el articulo. Código de estado: ${response.statusCode}');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF486D28),
                      ),
                      child: Text(
                        'Crear Articulo',
                        style: TextStyle(color: Color(0xFFFFFCEA)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 300),
            ],
          ),
        ),
      ),
    );
  }
}
