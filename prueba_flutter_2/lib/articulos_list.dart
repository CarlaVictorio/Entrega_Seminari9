import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ArticulosListPage extends StatefulWidget {
  @override
  _ArticulosListPageState createState() => _ArticulosListPageState();
}

class _ArticulosListPageState extends State<ArticulosListPage> {
  Map data = {};
  List articulosData = [];
  int currentPage = 1;
  int totalPages = 1;
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();

  getArticulos(int page) async {
    Uri url = Uri.parse('http://localhost:9090/articulos/readall/?page=$page');
    http.Response response = await http.get(url);
    data = json.decode(response.body);
    setState(() {
      articulosData.addAll(data['docs']);
      print(articulosData);
      currentPage = data['page'];
      totalPages = data['totalPages'];
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getArticulos(currentPage);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (currentPage < totalPages) {
          loadPage();
        }
      }
    });
  }

  void loadPage() {
    if (!isLoading && currentPage < totalPages) {
      setState(() {
        isLoading = true;
      });

      getArticulos(currentPage + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Lista de Artículos",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF486D28),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: articulosData.length + (isLoading ? 1 : 0),
              itemBuilder: (BuildContext context, int index) {
                final item = articulosData[index] as Map;
                final id = item['_id'] as String;
                if (index == articulosData.length) {
                  if (isLoading) {
                    return CircularProgressIndicator();
                  } else {
                    loadPage();
                    return SizedBox();
                  }
                }
                final articulosIndex = index;
                return Card(
                  color: Color(0xFF486D28),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "$articulosIndex",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFFFCEA),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                        ),
                        Text(
                          "${articulosData[articulosIndex]["name"]} ${articulosData[articulosIndex]["description"]}",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFFFCEA),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 30.0),
        child: FloatingActionButton(
          backgroundColor: Color(0xFF486D28),
          child: const Icon(Icons.add, color: Color(0xFFFFFCEA)),
          onPressed: () {
            Navigator.pushNamed(context, '/create_articulo');
          },
          shape: CircleBorder(),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ArticulosListPage(),
  ));
}
