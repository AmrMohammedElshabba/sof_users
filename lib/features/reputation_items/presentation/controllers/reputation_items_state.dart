part of 'reputation_items_cubit.dart';

@immutable
sealed class ReputationItemsState {}

final class ReputationItemsInitial extends ReputationItemsState {}

final class ReputationItemsLoading extends ReputationItemsState {}

final class ReputationItemsLoaded extends ReputationItemsState {}

class ReputationItemsFailure extends ReputationItemsState {
  final Failure failure;

  ReputationItemsFailure({required this.failure});
}
