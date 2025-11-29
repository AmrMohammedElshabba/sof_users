import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sof_users/core/local_storage/shared_pref_service.dart';
import '../../domain/models/sof_user.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../../../core/errors/failure.dart';

part 'sof_users_state.dart';

class SofUsersCubit extends Cubit<SofUsersState> {
  SofUsersCubit(this.getUsersUseCase, this.prefs) : super(SofUsersInitial());

  final GetUsersUseCase getUsersUseCase;
  final SharedPreferences prefs;

  static SofUsersCubit get(context) => BlocProvider.of(context);

  final int pageSize = 30;
  int page = 1;

  Set<int> _bookmarks = {};

  Set<int> get bookmarks => _bookmarks;

  bool isShowBookmarkedOnly = false;

  final ScrollController scrollController = ScrollController();

  List<SOFUser> sofUsers = [];
  bool hasMore = true;
  bool isLoadingMore = false;

  void initialCubit() {
    scrollController.addListener(_onScroll);
    loadBookmarks();
    loadSOFUsers();
  }

  void _onScroll() {
    if (!isShowBookmarkedOnly &&
        hasMore &&
        !isLoadingMore &&
        scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
      loadMoreSOFUsers();
    }
  }

  /// ---------------------- Load Users -------------------------
  void loadSOFUsers() async {
    emit(UsersLoading());

    page = 1;
    sofUsers.clear();
    hasMore = true;

    final response = await getUsersUseCase({
      "page": page,
      "pageSize": pageSize,
    });

    response.fold((failure) => emit(UsersFailure(failure: failure)), (
      List<SOFUser> users,
    ) {
      sofUsers.addAll(users);
      hasMore = users.length == pageSize;
      emit(UsersLoaded());
    });
  }

  void loadMoreSOFUsers() async {
    if (!hasMore || isLoadingMore) return;

    isLoadingMore = true;
    page += 1;

    final response = await getUsersUseCase({
      "page": page,
      "pageSize": pageSize,
    });

    response.fold(
      (failure) {
        emit(UsersFailure(failure: failure));
        isLoadingMore = false;
      },
      (List<SOFUser> users) {
        sofUsers.addAll(users);
        hasMore = users.length == pageSize;
        isLoadingMore = false;
        emit(UsersLoaded());
      },
    );
  }

  /// ---------------------- Bookmarks -------------------------
  void loadBookmarks() {
    final list = prefs.getStringList(SharedPrefsKeys.bookmarks) ?? [];
    _bookmarks = list
        .map((e) => int.tryParse(e) ?? 0)
        .where((e) => e != 0)
        .toSet();
    emit(BookmarkLoaded());
  }

  void toggleBookmarks(int userId) async {
    if (_bookmarks.contains(userId)) {
      _bookmarks.remove(userId);
    } else {
      _bookmarks.add(userId);
    }

    await prefs.setStringList(
      SharedPrefsKeys.bookmarks,
      _bookmarks.map((e) => e.toString()).toList(),
    );

    emit(BookmarkLoaded());
  }


  void showBookMarkOnly() {
    isShowBookmarkedOnly = !isShowBookmarkedOnly;
    emit(ShowBookMarkOnly());
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}
