part of 'sof_users_cubit.dart';

@immutable
sealed class SofUsersState {}

class SofUsersInitial extends SofUsersState {}

class UsersLoading extends SofUsersState {}

class UsersFailure extends SofUsersState {
  final Failure failure;

  UsersFailure({required this.failure});
}

class UsersLoaded extends SofUsersState {}

class BookmarkLoaded extends SofUsersState {


}

class ShowBookMarkOnly extends SofUsersState {}
