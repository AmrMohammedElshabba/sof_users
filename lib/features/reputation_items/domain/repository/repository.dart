import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/reputation_item.dart';

abstract class GetReputationItemRepo {
  Future<Either<Failure, List<ReputationItem>>> fetchReputation({
    required int userId,
    required int page,
    int pageSize = 30,
  });
}
