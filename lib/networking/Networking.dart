import 'dart:convert';
import 'package:flutter_json_place_holder/helpers/Constants.dart';
import 'package:flutter_json_place_holder/models/Post.dart';
import 'package:http/http.dart';

class Networking{

  static Future<List<Post>> getPostsOnline() async {
    final response = await get(Uri.parse(POSTS_END_POINT)); //returns json wrapped in a response object.

    if (response.statusCode == 200) {
      List<Post> posts = (json.decode(response.body) as List)
          .map((data) => Post.fromJson(data))
          .toList();
      print(posts.length);
      return posts;
    }
    else {
      print("Error");
      throw Exception('Failed to load posts');
    }
  }

  static Future<Post> getPostByIdOnline(String postId) async {
    final response = await get(Uri.parse("$POST_END_POINT$postId")); //returns json wrapped in a response object.
    if (response.statusCode == 200) {
      Post post = Post.fromJson(jsonDecode(response.body));
      return post;
    }
    else {
      throw Exception('Failed to load post');
    }
  }
}