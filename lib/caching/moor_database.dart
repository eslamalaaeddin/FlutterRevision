import 'package:flutter_json_place_holder/models/LocalPost.dart';
import 'package:flutter_json_place_holder/models/Post.dart';
import 'package:moor/moor.dart';
import 'package:moor/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'moor_database.g.dart';

//THIS FILE HAS TO BE NAME AS moor_database IN ORDER "PART" TO WORK
LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}


@UseMoor(tables: [LocalPost])
class PostsDatabase extends _$PostsDatabase {
// we tell the database where to store the data with this constructor
  PostsDatabase() : super(_openConnection());

  Future<List<local_posts>> get getAllPosts => select(localPost).get();


  Future<void> insertMultipleEntries(List<local_posts> posts) async{
    await batch((batch) {
      // functions in a batch don't have to be awaited - just
      // await the whole batch afterwards.
      batch.insertAllOnConflictUpdate(localPost, posts);
    });
  }

  Stream<local_posts> getEntryById(int id) {
    return (select(localPost)..where((t) => t.id.equals(id))).watchSingle();
  }



  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;
}