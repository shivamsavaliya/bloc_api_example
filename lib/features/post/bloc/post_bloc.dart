import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fetch_api_bloc/features/post/models/post_data_ui_model.dart';
import 'package:fetch_api_bloc/features/post/repos/post_repo.dart';
import 'package:meta/meta.dart';
part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial()) {
    on<PostInitialFetchEvent>(postInitialFetchEvent);
    on<PostAddEvent>(postAddEvent);
  }

  FutureOr<void> postInitialFetchEvent(
      PostInitialFetchEvent event, Emitter<PostState> emit) async {
    emit(PostFetchingLoadingState());
    List<PostDataUiModel> posts = await PostRepo.fetchPost();
    emit(PostFetchingSuccessfulState(posts: posts));
    //emit(PostFetchingErrorfulState());
  }

  FutureOr<void> postAddEvent(
      PostAddEvent event, Emitter<PostState> emit) async {
    bool success = await PostRepo.addPost(event.title, event.body);
    if (success) {
      emit(PostAdditionSuccessState());
    } else {
      emit(PostAdditionErrorState());
    }
  }
}
