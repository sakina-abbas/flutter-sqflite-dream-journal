import 'models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  static const String TABLE_DREAM = 'dream';
  static const String COLUMN_ID = 'id';
  static const String COLUMN_TITLE = 'title';
  static const String COLUMN_DETAILS = 'details';

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    print('database getter called');

    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'dreamDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print('Creating dream table');

        await database.execute(
          "CREATE TABLE $TABLE_DREAM ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$COLUMN_TITLE TEXT,"
          "$COLUMN_DETAILS TEXT"
          ")",
        );
      },
    );
  }

  Future<List<Dream>> getDreams() async {
    final db = await database;

    var dreams = await db.query(
        TABLE_DREAM,
        columns: [COLUMN_ID, COLUMN_TITLE, COLUMN_DETAILS],
        orderBy: '$COLUMN_ID desc',
    );

    List<Dream> dreamsList = [];

    dreams.forEach((currentDream) {
      Dream dream = Dream.fromMap(currentDream);

      dreamsList.add(dream);
    });

    return dreamsList;
  }

  Future<List<Dream>> getDreamsByName(String keyword) async {
    final db = await database;

    var dreams = await db.query(
      TABLE_DREAM,
      columns: [COLUMN_ID, COLUMN_TITLE, COLUMN_DETAILS],
      orderBy: '$COLUMN_ID desc',
      where: '$COLUMN_TITLE LIKE ?',
      whereArgs: ['%$keyword%']
    );

    List<Dream> dreamsList = [];

    dreams.forEach((currentDream) {
      Dream dream = Dream.fromMap(currentDream);

      dreamsList.add(dream);
    });

    return dreamsList;
  }

  Future<Dream> insert(Dream dream) async {
    final db = await database;
    dream.id = await db.insert(TABLE_DREAM, dream.toMap());
    return dream;
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      TABLE_DREAM,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(Dream dream) async {
    final db = await database;

    return await db.update(
      TABLE_DREAM,
      dream.toMap(),
      where: 'id = ?',
      whereArgs: [dream.id],
    );
  }
}
