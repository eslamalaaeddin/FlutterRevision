import 'package:flutter_json_place_holder/caching/moor_database.dart';
import 'package:flutter_json_place_holder/models/LocalPost.dart';

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body']
    );
  }

  local_posts getLocalPost(){
    return local_posts(userId: this.userId, id: this.id, title: this.title, body: this.body);
  }

  @override
  String toString() {
    return "$id - $title";
  }
}
