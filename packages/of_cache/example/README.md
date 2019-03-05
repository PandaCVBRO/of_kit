## Base Object

```json
{
    "json": {
        "data": "qqnxI"
    },
    "updatedAt": "2019-02-20 08:50:49"
}
```

## Basic Usage

```dart
# 0.Get KvStore Instance
KvStore()

# Save/Update Key-Value pair in default collection(table in sqlite)
KvStore().putObject('city', {'data': randomAlpha(5)})

# Get object(row in sqlite) by Key
KvStore().getObjectByKey('name')

# Get object count
KvStore().getCountFromTable()

# Get all objects
KvStore().getAllItems()

# Delete object by key
KvStore().deleteObjectByKey('name')

# Delete multiple objects by keys
KvStore().deleteObjectsByKeys(['name', 'city'])

# Delete multiple objects by prefix
KvStore().deleteObjectsByKeyPrefix('c')

# Delete all objects
KvStore().clearTable()
```

## Advanced Usage

```dart
# Create new database
KvStore().createTable('t_example')

# Get databases
KvStore().allTables()

# Actions in specified database
KvStore().putObject(randomAlpha(5), {'data': randomAlpha(5)}, 't_example')

# Delete database
KvStore().dropTable('t_example')
```