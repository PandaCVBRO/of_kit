import 'package:flutter/material.dart';

class KVStorageDemoPage extends StatefulWidget {
  KVStorageDemoPage({Key key}) : super(key: key);

  _KVStorageDemoPageState createState() => _KVStorageDemoPageState();
}

class _KVStorageDemoPageState extends State<KVStorageDemoPage> {
  List<String> logs = [
    'laskjlf',
    'alsdjflkasjdlkfjasldjflkajsdlkfjalsjlfajsdf',
    'lkajsdlkfjalskdjflkajsdlkf'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Key Value Storage Demo'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: Text(logs[index]),
                  );
                },
              ),
            ),
            Expanded(
              child: Container(
                  color: Colors.grey[100],
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: <Widget>[],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
