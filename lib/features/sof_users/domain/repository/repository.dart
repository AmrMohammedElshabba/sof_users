import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/sof_user.dart';

abstract class GetSOFUsersRepo {

  Future<Either<Failure, List<SOFUser>>> fetchUsers({
    required int page,
    int pageSize = 30,
  });
}