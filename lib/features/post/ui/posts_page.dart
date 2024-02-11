import 'package:fetch_api_bloc/features/post/bloc/post_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final PostBloc postBloc = PostBloc();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  @override
  void initState() {
    postBloc.add(PostInitialFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Page'),
      ),
      body: BlocConsumer<PostBloc, PostState>(
        bloc: postBloc,
        listenWhen: (previous, current) => current is PostActionState,
        buildWhen: (previous, current) => current is! PostActionState,
        listener: (context, state) {
          if (state is PostFetchingErrorfulState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("there is some error while fetching the data"),
              ),
            );
          } else if (state is PostAdditionSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text("Post Added Successfully"),
              ),
            );
          } else if (state is PostAdditionErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text("Post not added!!!"),
              ),
            );
          }
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case PostFetchingLoadingState:
              return const Center(
                child: CircularProgressIndicator(),
              );

            case PostFetchingSuccessfulState:
              final success = state as PostFetchingSuccessfulState;
              return ListView.builder(
                itemCount: success.posts.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    title: Text(
                      success.posts[index].title.toString(),
                    ),
                    subtitle: Text(success.posts[index].body.toString()),
                  ),
                ),
              );
            default:
              return const Center(child: Text('Not getting anything'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dialogBoxWidget(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> dialogBoxWidget(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: title,
                decoration: const InputDecoration(hintText: "Title"),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: body,
                decoration: const InputDecoration(hintText: "Body"),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  postBloc.add(
                    PostAddEvent(
                      title: title.text,
                      body: body.text,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
