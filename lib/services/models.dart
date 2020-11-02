import 'db_provider.dart';

class Dream {
  int id;
  String title;
  String details;

  Dream({this.id, this.title, this.details});

  /// serialise object when writing to database
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_ID: id,
      DatabaseProvider.COLUMN_TITLE: title,
      DatabaseProvider.COLUMN_DETAILS: details,
    };

    return map;
  }

  /// deserialise object when reading from database
  Dream.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    title = map[DatabaseProvider.COLUMN_TITLE];
    details = map[DatabaseProvider.COLUMN_DETAILS];
  }
}
