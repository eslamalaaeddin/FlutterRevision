import 'package:flutter/material.dart';
import 'package:flutter_json_place_holder/models/Post.dart';
import 'package:flutter_json_place_holder/screens/PostScreen.dart';

class SearchEngine extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Post searchedPost = Post();

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(searchedPost.title),
      ),
    );
  }

  final List<Post> listExample;
  SearchEngine(this.listExample);


  @override
  Widget buildSuggestions(BuildContext context) {
    List<Post> suggestionList = [];
    query.isEmpty
        ? List.empty() //In the true case
        : suggestionList.addAll(listExample.where((element) => element.title.contains(query),
    ));

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            suggestionList[index].title,
          ),
          leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
          onTap: (){
            searchedPost = suggestionList[index];
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostScreen(postId: searchedPost.id.toString(), postTitle: searchedPost.title,)));
            //showResults(context);
          },
        );
      },
    );
  }
}