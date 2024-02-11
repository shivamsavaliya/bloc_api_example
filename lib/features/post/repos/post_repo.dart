import 'dart:convert';
import 'dart:developer';

import 'package:fetch_api_bloc/features/post/models/post_data_ui_model.dart';
import 'package:http/http.dart' as http;

class PostRepo {
  static Future<List<PostDataUiModel>> fetchPost() async {
    List<PostDataUiModel> postList = [];
    try {
      var response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );
      List result = jsonDecode(response.body);
      for (var i = 0; i < result.length; i++) {
        PostDataUiModel post = PostDataUiModel.fromJson(result[i]);
        postList.add(post);
      }
      return postList;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  static Future<bool> addPost(String title, String body) async {
    try {
      var response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        body: {
          "title": title,
          "body": body,
          "userId": '22',
        },
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
