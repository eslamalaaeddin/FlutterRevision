
import 'package:flutter_json_place_holder/models/Post.dart';
import 'package:moor/moor.dart';

@DataClassName("local_posts")
class LocalPost extends Table {
  IntColumn get userId => integer()();
  IntColumn get id => integer()();
  TextColumn get title => text()();
  TextColumn get body => text()();

  @override
  Set<Column> get primaryKey => {id};

  LocalPost({userId, id, title, body});



}
