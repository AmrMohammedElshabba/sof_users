import 'package:dartz/dartz.dart';
import 'package:sof_users/core/errors/failure.dart';
import 'package:sof_users/core/generic_usecase/generic_usecase.dart';
import 'package:sof_users/features/sof_users/domain/models/sof_user.dart';

import '../repository/repository.dart';

class GetUsersUseCase
    extends GenericUseCase<List<SOFUser>, Map<String, dynamic>> {
  final GetSOFUsersRepo getSOFUsersRepo;

  GetUsersUseCase({required this.getSOFUsersRepo});

  @override
  Future<Either<Failure, List<SOFUser>>> call(Map<String, dynamic> params) {
    return getSOFUsersRepo.fetchUsers(
      page: params["page"],
      pageSize: params["pageSize"],
    );
  }
}
