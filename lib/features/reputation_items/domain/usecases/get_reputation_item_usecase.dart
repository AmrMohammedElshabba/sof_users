import 'package:dartz/dartz.dart';
import 'package:sof_users/core/errors/failure.dart';
import 'package:sof_users/core/generic_usecase/generic_usecase.dart';
import 'package:sof_users/features/reputation_items/domain/models/reputation_item.dart';
import 'package:sof_users/features/sof_users/domain/models/sof_user.dart';

import '../repository/repository.dart';

class GetReputationItemUseCase
    extends GenericUseCase<List<ReputationItem>, Map<String, dynamic>> {
  final GetReputationItemRepo getReputationItemRepo;

  GetReputationItemUseCase({required this.getReputationItemRepo});

  @override
  Future<Either<Failure, List<ReputationItem>>> call(
    Map<String, dynamic> params,
  ) {
    return getReputationItemRepo.fetchReputation(
      page: params["page"],
      pageSize: params["pageSize"],
      userId: params["userId"],
    );
  }
}
