import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sof_users/features/reputation_items/domain/models/reputation_item.dart';
import 'package:sof_users/features/reputation_items/domain/usecases/get_reputation_item_usecase.dart';
import 'package:sof_users/features/sof_users/domain/models/sof_user.dart';

import '../../../../core/errors/failure.dart';

part 'reputation_items_state.dart';

class ReputationItemsCubit extends Cubit<ReputationItemsState> {
  ReputationItemsCubit(this.getReputationItemUseCase)
    : super(ReputationItemsInitial());

  final GetReputationItemUseCase getReputationItemUseCase;

  static ReputationItemsCubit get(context) => BlocProvider.of(context);

  final int pageSize = 30;
  int page = 1;
  final ScrollController scrollController = ScrollController();

  List<ReputationItem> reputationItems = [];
  late final SOFUser sofUser;
  bool hasMore = true;
  bool isLoadingMore = false;

  void initialCubit({required SOFUser user}) {
    sofUser =user;
    scrollController.addListener(_onScroll);
    loadReputationItems();
  }

  void _onScroll() {
    if (hasMore &&
        !isLoadingMore &&
        scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
      loadMoreReputationItems();
    }
  }

  /// ---------------------- Load Reputation Items -------------------------
  void loadReputationItems() async {
    emit(ReputationItemsLoading());

    page = 1;
    reputationItems.clear();
    hasMore = true;

    final response = await getReputationItemUseCase({
      "page": page,
      "pageSize": pageSize,
      "userId": sofUser.userId
    });

    response.fold((failure) => emit(ReputationItemsFailure(failure: failure)), (
      List<ReputationItem> users,
    ) {
      reputationItems.addAll(users);
      hasMore = users.length == pageSize;
      emit(ReputationItemsLoaded());
    });
  }

  void loadMoreReputationItems() async {
    if (!hasMore || isLoadingMore) return;

    isLoadingMore = true;
    page += 1;

    final response = await getReputationItemUseCase({
      "page": page,
      "pageSize": pageSize,
      "userId": sofUser.userId
    });

    response.fold(
      (failure) {
        emit(ReputationItemsFailure(failure: failure));
        isLoadingMore = false;
      },
      (List<ReputationItem> users) {
        reputationItems.addAll(users);
        hasMore = users.length == pageSize;
        isLoadingMore = false;
        emit(ReputationItemsLoaded());
      },
    );
  }
  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}
