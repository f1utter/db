import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DBPrac {
  String serialNo = '';
  String dbData = '';
  DBPrac({required this.serialNo, required this.dbData});
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.teal), home: const DBScaffold());
  }
}

class DBScaffold extends StatefulWidget {
  const DBScaffold({Key? key}) : super(key: key);
  @override
  State<DBScaffold> createState() => _DBScaffoldState();
}

class _DBScaffoldState extends State<DBScaffold> {
  var serialNoController = TextEditingController();
  var dbDataController = TextEditingController();
  final GlobalKey<FormState> dbForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Practice'),
      ),
      body: Form(
        key: dbForm,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
          child: Column(
            children: [
              TextFormField(
                  controller: serialNoController,
                  validator: (String? value){
                    if(value!.isEmpty){
                      return 'Enter value';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      hintText: 'Serial Number',
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.cyan, width: 2)))),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: dbDataController,
                validator: (String? value){
                  if(value!.isEmpty){
                    return 'Enter value';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    hintText: 'Data',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan, width: 2))),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      add();

                    },
                    child: const Icon(Icons.add),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (dbForm.currentState!.validate()) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('All Records'),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'OK'),
                                      child: const Text('OK'))
                                ],
                                content: FutureBuilder<List<dynamic>?>(
                                    future: view(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        print(snapshot.error);
                                        return Container();
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasData) {
                                        final List<dynamic>? view =
                                            snapshot.data;
                                        return SizedBox(
                                          height: 300,
                                          width: 300,
                                          child: ListView.builder(
                                              itemCount: view?.length,
                                              itemBuilder:
                                                  (BuildContext context, index) {
                                                return Text(
                                                    'S.No.: ${view![index]['serialNo']}\n'
                                                    'Data: ${view[index]['dbData']}');
                                              }),
                                        );
                                      }
                                      return Container();
                                    }),
                              );
                            });
                      }
                    },
                    child: const Text('View All'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String dbUri = "http://10.17.65.186:5000";
  Future<void> add() async {
    DBPrac sample = DBPrac(
        serialNo: serialNoController.text, dbData: dbDataController.text);
    final response =
        await http.post(Uri.parse('$dbUri/add'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'serialNo': sample.serialNo,
      'dbData': sample.dbData
    });
  }

  Future<List> view() async {
    http.Response response = await http.get(Uri.parse('$dbUri/view'));
    Map data = json.decode(response.body);
    List data1 = data['result'];
    return data1;
  }
}
