import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'pages/kv_storage_demo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  final List dataSource = [
    [
      'of_kv_storage Demo',
      KVStorageDemoPage(),
    ],
    [
      'of_disk_cache Demo',
    ],
    [
      'of_memory_cache Demo',
    ]
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("of_cache Demo")),
        body: ListView.builder(
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(dataSource[index][0]),
              onTap: () {
                if (dataSource[index].length == 1) return;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => dataSource[index][1]));
              },
            );
          },
        ),
      ),
    );
  }
}
