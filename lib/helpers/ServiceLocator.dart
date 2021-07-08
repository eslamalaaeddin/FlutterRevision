import 'package:flutter_json_place_holder/caching/moor_database.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

Future setupLocator() async {
  locator.registerSingleton(PostsDatabase());
}