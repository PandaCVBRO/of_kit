import 'dart:async';
import 'dart:io';
import 'dart:core';
import 'dart:convert';

import 'package:path/path.dart';
import 'package:sprintf/sprintf.dart';
import 'package:sqflite/sqflite.dart';

import 'package:of_logger/of_logger.dart';

class KvStore {
  factory KvStore() => _getInstance();
  static KvStore get instance => _getInstance();
  static KvStore _isntance;

  Future<Database> db;

  KvStore._internal() {
    db = database();
  }

  static KvStore _getInstance() {
    if (_isntance == null) {
      _isntance = KvStore._internal();
      OFLogger.info('Create new instance(shared).');
    }
    return _isntance;
  }

  Future<Database> database([dbName = 'kv_store.db']) async {
    String path = join(await getDatabasesPath(), dbName);

    if (!await Directory(dirname(path)).exists()) {
      try {
        Directory dir = await Directory(dirname(path)).create(recursive: true);
        OFLogger.info('Database path is ${dir.path}');
      } catch (e) {
        OFLogger.error(e.toString());
      }
    }

    // open the database
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(sprintf(create_table_sql, [default_table]));
    });

    OFLogger.info('Database opened $path');
    return database;
  }

  Future<int> createTable([String tableName = default_table]) async {
    if (!_checkTableName(tableName)) {
      OFLogger.error('Action: createTable($tableName)');
      return 0;
    }

    Database db = await this.db;
    OFLogger.info('Action: createTable($tableName)');
    return await db.rawUpdate(sprintf(create_table_sql, [tableName]));
  }

  Future<List> allTables() async {
    Database db = await this.db;
    List tables = await db.rawQuery(select_all_tables);

    List r = tables.map((item) {
      return item['name'];
    }).toList();

    OFLogger.info('Action: allTables(), result:\n' +
        JsonEncoder.withIndent('    ').convert(r));
    return r;
  }

  Future<int> clearTable([String tableName = default_table]) async {
    if (!_checkTableName(tableName)) {
      return 0;
    }

    Database db = await this.db;
    int effectRows = await db.rawUpdate(sprintf(clear_all_sql, [tableName]));
    OFLogger.info('Action: clearTable($tableName), Effect rows: $effectRows');
    return effectRows;
  }

  Future<int> dropTable([String tableName = default_table]) async {
    if (!_checkTableName(tableName)) {
      return 0;
    }

    Database db = await this.db;
    try {
      await db.rawDelete(sprintf(drop_table_sql, [tableName]));
      OFLogger.info('Action: dropTable($tableName), Effect rows 1');
      return 1;
    } catch (e) {
      OFLogger.error('Action: dropTable($tableName), ${e.toString()}');
      return 0;
    }
  }

  Future<int> putObject(String key, Map value,
      [String tableName = default_table]) async {
    if (!_checkTableName(tableName)) {
      return 0;
    }

    Database db = await this.db;
    String jsonValue = json.encode(value);
    int effectRows =
        await db.rawUpdate(sprintf(update_sql, [tableName]), [key, jsonValue]);
    OFLogger.info(
        'Action: putObject($key, $value, $tableName), Effect rows: $effectRows');
    return effectRows;
  }

  Future<dynamic> getObjectByKey(String key,
      [String tableName = default_table]) async {
    if (!_checkTableName(tableName)) {
      return {};
    }

    Database db = await this.db;
    List items = await db.rawQuery(sprintf(query_item_sql, [tableName]), [key]);

    if (items.length == 0) {
      OFLogger.warning(
          'Action: getObjectByKey($key, $tableName), Query result is EMPTY.');
      return {};
    }

    var item = {};
    item.addAll(items[0]);
    item['json'] = json.decode(item['json']);
    OFLogger.info('Action: getObjectByKey($key, $tableName), result:\n' +
        JsonEncoder.withIndent('    ').convert(item));
    return item;
  }

  Future<dynamic> getAllItems([String tableName = default_table]) async {
    if (!_checkTableName(tableName)) {
      return [];
    }

    Database db = await this.db;
    List items = await db.rawQuery(sprintf(select_all_sql, [tableName]));

    List result = [];
    for (Map item in items) {
      var r = {};
      r.addAll(item);
      r['json'] = json.decode(item['json']);
      result.add(r);
    }

    OFLogger.info('Action: getAllItems($tableName), result:\n' +
        JsonEncoder.withIndent('    ').convert(result));

    return result;
  }

  Future<int> getCountFromTable([String tableName = default_table]) async {
    if (!_checkTableName(tableName)) {
      return 0;
    }

    Database db = await this.db;
    int count = Sqflite.firstIntValue(
        await db.rawQuery(sprintf(count_all_sql, [tableName])));

    OFLogger.info('Action: getCountFromTable($tableName), result: $count');
    return count;
  }

  Future<int> deleteObjectByKey(String key,
      [String tableName = default_table]) async {
    if (!_checkTableName(tableName)) {
      return 0;
    }

    Database db = await this.db;
    int effectRows =
        await db.rawDelete(sprintf(delete_item_sql, [tableName]), [key]);

    OFLogger.info(
        'Action: deleteObjectByKey($key, $tableName), Effect rows: $effectRows');

    return effectRows;
  }

  Future<int> deleteObjectsByKeys(List keys,
      [String tableName = default_table]) async {
    if (!_checkTableName(tableName)) {
      return 0;
    }

    String sql = sprintf(delete_items_sql, [
      tableName,
      keys
          .map((item) {
            return '"$item"';
          })
          .toList()
          .join(',')
    ]);

    Database db = await this.db;
    int effectRows = await db.rawDelete(sql);
    OFLogger.info(
        'Action: deleteObjectsByKeys($keys, $tableName), Effect rows: $effectRows');

    return effectRows;
  }

  Future<int> deleteObjectsByKeyPrefix(String prefix,
      [String tableName = default_table]) async {
    if (!_checkTableName(tableName)) {
      return 0;
    }

    Database db = await this.db;
    int effectRows = await db.rawDelete(
        sprintf(delete_items_with_prefix_sql, [tableName]), [prefix + '%']);
    OFLogger.info(
        'Action: deleteObjectsByKeyPrefix($prefix, $tableName), Effect rows: $effectRows');
    return effectRows;
  }

  bool _checkTableName(String tableName) {
    if (tableName == null || tableName.length == 0 || tableName.contains(' ')) {
      OFLogger.error(
          'Action: _checkTableName($tableName), Table name format error.');
      return false;
    }
    return true;
  }
}

const String select_all_tables =
    'select * from sqlite_master where type="table"';
const String create_table_sql =
    'CREATE TABLE IF NOT EXISTS %s (id TEXT NOT NULL, json TEXT NOT NULL, updatedAt TEXT NOT NULL, PRIMARY KEY(id))';
const String update_sql =
    'REPLACE INTO %s (id, json, updatedAt) values (?, ?, datetime("now"))';
const String query_item_sql =
    'SELECT json, updatedAt from %s where id = ? Limit 1';
const String select_all_sql = 'SELECT * from %s';
const String count_all_sql = 'SELECT count(*) as num from %s';
const String clear_all_sql = 'DELETE from %s';
const String delete_item_sql = 'DELETE from %s where id = ?';
const String delete_items_sql = 'DELETE from %s where id in (%s)';
const String delete_items_with_prefix_sql = 'DELETE from %s where id like ?';
const String drop_table_sql = 'DROP TABLE "%s"';

const String default_table = 't_default';
const String preferences_table = 't_preferences';
