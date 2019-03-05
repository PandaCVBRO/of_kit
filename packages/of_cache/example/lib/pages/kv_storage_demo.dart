import 'package:flutter/material.dart';
import 'package:of_cache/kv_storage.dart';
import 'dart:convert';
import 'package:random_string/random_string.dart';

class KVStorageDemoPage extends StatefulWidget {
  KVStorageDemoPage({Key key}) : super(key: key);

  _KVStorageDemoPageState createState() => _KVStorageDemoPageState();
}

class _KVStorageDemoPageState extends State<KVStorageDemoPage> {
  List<String> logs = [
    '日志:',
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
                itemCount: logs.length * 2,
                itemBuilder: (context, index) {
                  return index % 2 == 0
                      ? Container(
                          padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                          child: Text(logs[index ~/ 2]),
                        )
                      : Divider();
                },
              ),
            ),
            Divider(color: Colors.blueGrey),
            Expanded(
                child: ListView.builder(
              itemCount: actions.length,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.blue[index % 2 * 100 + 200],
                  child: ListTile(
                    title: Text(
                      index.toString() + '  ' + actions[index]['title'],
                      style: TextStyle(fontSize: 14),
                    ),
                    onTap: () {
                      _runAndRecord(actions[index]['id']);
                    },
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> actions = [
    {"title": "获取所有表", 'id': 0},
    {"title": "创建默认表", 'id': 1},
    {"title": "创建名为 t_example 的表", "id": 2},
    {"title": "向 t_example 中插入一条随机数据", "id": 3},
    {"title": "从 t_example 清除所有表中数据", "id": 4},
    {"title": "向 t_example 中插入一条 key 为 name 的随机数据", "id": 5},
    {"title": "向 t_example 中插入一条 key 为 city 的随机数据", "id": 6},
    {"title": "向 t_example 中插入一条 key 为 code 的随机数据", "id": 7},
    {"title": "取 t_example 中 key 为 name 的数据", "id": 8},
    {"title": "从 t_example 中删除一条 key 为 name 的数据", "id": 9},
    {"title": "从 t_example 中删除 key 为 [name, city] 的数据", "id": 10},
    {"title": "从 t_example 中删除一条 key 前缀为 c 的数据", "id": 11},
    {"title": "获取 t_example 表中数据的条数", "id": 12},
    {"title": "获取 t_example 表中全部数据", "id": 13},
    {"title": "删除 t_example 表", "id": 14},
  ];

  void _runAndRecord(int id) async {
    String log = await _selectAndRun(id);
    logs.insert(0, log);
    setState(() {});
  }

  Future<String> _selectAndRun(int id) async {
    switch (id) {
      case 0:
        return json.encode(await KvStore().allTables());
      case 1:
        return (await KvStore().createTable()).toString();
      case 2:
        return (await KvStore().createTable('t_example')).toString();
      case 3:
        return (await KvStore().putObject(
                randomAlpha(5), {'data': randomAlpha(5)}, 't_example'))
            .toString();
      case 4:
        return (await KvStore().clearTable('t_example')).toString();
      case 5:
        return (await KvStore()
                .putObject('name', {'data': randomAlpha(5)}, 't_example'))
            .toString();
      case 6:
        return (await KvStore()
                .putObject('city', {'data': randomAlpha(5)}, 't_example'))
            .toString();
      case 7:
        return (await KvStore()
                .putObject('code', {'data': randomAlpha(5)}, 't_example'))
            .toString();
      case 8:
        return JsonEncoder.withIndent('    ')
            .convert(await KvStore().getObjectByKey('name', 't_example'));
      case 9:
        return (await KvStore().deleteObjectByKey('name', 't_example'))
            .toString();
      case 10:
        return (await KvStore()
                .deleteObjectsByKeys(['name', 'city'], 't_example'))
            .toString();
      case 11:
        return (await KvStore().deleteObjectsByKeyPrefix('c', 't_example'))
            .toString();

      case 12:
        return (await KvStore().getCountFromTable('t_example')).toString();
      case 13:
        return JsonEncoder.withIndent('    ')
            .convert(await KvStore().getAllItems('t_example'));
      case 14:
        return (await KvStore().dropTable('t_example')).toString();
    }

    return 'NotFound';
  }
}
