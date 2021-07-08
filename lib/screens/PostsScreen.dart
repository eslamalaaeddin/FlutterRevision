import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_place_holder/caching/moor_database.dart';
import 'package:flutter_json_place_holder/helpers/Constants.dart';
import 'package:flutter_json_place_holder/helpers/SearchEngine.dart';
import 'package:flutter_json_place_holder/helpers/ServiceLocator.dart';
import 'package:flutter_json_place_holder/helpers/Utils.dart';
import 'package:flutter_json_place_holder/models/Post.dart';
import 'package:flutter_json_place_holder/networking/Networking.dart';
import 'package:flutter_json_place_holder/screens/PostScreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PostsScreen extends StatefulWidget {


  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
   Future<List<Post>> posts;
   Post currentPost;
   List<Post>postsToSearch = List.empty();
   var connectionState = -1;
   PostsDatabase postsDatabase;

   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
   FlutterLocalNotificationsPlugin();


  @override
  void initState()  {
    super.initState();



    var initializationSettingsAndroid =
    AndroidInitializationSettings('flutter_devs');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);

    posts = Networking.getPostsOnline();
    postsDatabase =  locator<PostsDatabase>();
    asyncMethod();
  }

   Future onSelectNotification(String payload) {
     navigateToPostScreen(currentPost.id.toString(), currentPost.title);
   }

   showNotification() async {
     var android = new AndroidNotificationDetails(
         'id', 'channel ', 'description',
         priority: Priority.high, importance: Importance.max);
     var iOS = new IOSNotificationDetails();
     var platform = new NotificationDetails(android: android, iOS: iOS);
     await flutterLocalNotificationsPlugin.show(
         0, currentPost.title, currentPost.body, platform,
         payload: 'Welcome to the Local Notification demo ');
   }

   void asyncMethod() async {
    await Utils.getConnectionState().then((value) => connectionState = value) ;

    if(connectionState == 1) {
      print('ONLINE');
      posts = Networking.getPostsOnline();
    }
    // value.map((e) => Post(userId: e.userId, id: e.id, title: e.title, body: e.body))
    else {
      print('OFFLINE');
      var listPosts = List.empty(growable: true);
      await postsDatabase.getAllPosts.then((value) => listPosts = value);
      postsToSearch = getListPost(listPosts);
    }
   }

  List<Post> getListPost(List<local_posts> l) {
    List<Post> list = List.empty(growable: true);
    l.forEach((e) {
      var post = Post(userId: e.userId, id: e.id, title: e.title, body: e.body);
      list.add(post);
    });
    return list;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.redAccent,
      automaticallyImplyLeading: false,//to remove the up button
      actions: <Widget>[
        IconButton(
          onPressed: () {
            showSearch(context: context, delegate: SearchEngine(postsToSearch));
          },
          icon: Icon(Icons.search),
        )
      ],
      title: Text('Search by title...'),
    ), body: Container(
        child: FutureBuilder<List<Post>>(
          future: posts,
          builder: (context, snapshot) {
            if(connectionState == 1){
              if (snapshot.hasData) {
                print(snapshot.data.length);
                postsToSearch = snapshot.data;

                postsDatabase.insertMultipleEntries(postsToSearch.map((e) => e.getLocalPost()).toList());

                return ListView.builder(itemCount: snapshot.data.length,itemBuilder:(context, index) {
                  return cardWidget(snapshot.data[index]);
                } );
              }
              else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
            }
            else{
              return ListView.builder(itemCount: postsToSearch.length,itemBuilder:(context, index) {
                return cardWidget(postsToSearch[index]);
              } );
            }
            return Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                height: 36.0,
                width: 36.0,
              ),
            );
          },
        )
    ),
  );

  Card cardWidget(Post post){
    return Card(
      child: ListTile(
        onTap: (){
          currentPost = post;
          showNotification();
          // navigateToPostScreen(post.id.toString(), post.title);
          },
        onLongPress: () {},
        title: Text(post.title),
        subtitle: Text(post.body),
      ),
    );
  }

  void navigateToPostScreen(String postId, String postTitle) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostScreen(postId: postId, postTitle: postTitle,)));

}



