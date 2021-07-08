import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_place_holder/caching/moor_database.dart';
import 'package:flutter_json_place_holder/helpers/ServiceLocator.dart';
import 'package:flutter_json_place_holder/helpers/Utils.dart';
import 'package:flutter_json_place_holder/models/Post.dart';
import 'package:flutter_json_place_holder/networking/Networking.dart';

class PostScreen extends StatefulWidget {
  final String postId;
  final String postTitle;

  const PostScreen({this.postId, this.postTitle}) : super();

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Future<Post> postFuture;
  Post post = Post(title: " ", body: " ");
  Map data = {};
  var connectionState = -1;
  PostsDatabase postsDatabase;

  @override
  void initState() {
    super.initState();
    print(widget.postId);
    postsDatabase =  locator<PostsDatabase>();
    postFuture = Networking.getPostByIdOnline(widget.postId);
    method();

  }

  void method() async {
    await Utils.getConnectionState().then((value) => connectionState = value) ;

    if(connectionState == 1) {
      print('ONLINE');
      postFuture = Networking.getPostByIdOnline(widget.postId);
    }
    else {
      local_posts l ;
      print('OFFLINE');
      await postsDatabase.getEntryById(int.parse(widget.postId)).first.then((value) => l = value);

      post = Post(userId: l.userId, id: l.id, title: l.title, body: l.body);
      setState(() {});

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(widget.postTitle),
        centerTitle: true,
      ),
      body: FutureBuilder<Post>(
        future: postFuture,
        builder: (context, snapshot) {
          if(connectionState == 1){
            if (snapshot.hasData) {
              return cardWidget(snapshot.data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
          }

          else{
            return cardWidget(post);
          }

          return Center(
            child: SizedBox(
              child: CircularProgressIndicator(),
              height: 36.0,
              width: 36.0,
            ),
          );
        },
      ),
    );
  }

  Card cardWidget(Post post) {
    return Card(
      child: Wrap(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(post.userId.toString() == "null" ? "" : post.userId.toString()),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(post.id.toString() == "null" ? "" : post.id.toString()),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(post.title),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(post.body),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
