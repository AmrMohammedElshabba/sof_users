import 'package:sof_users/core/network/api_client.dart';
import 'package:sof_users/features/reputation_items/domain/models/reputation_item.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/utilities/endpoints.dart';
import '../../domain/repository/repository.dart';

class GetReputationItemImpRepo implements GetReputationItemRepo {
  final ApiClient apiClient;

  GetReputationItemImpRepo({required this.apiClient});

  @override
  Future<Either<Failure, List<ReputationItem>>> fetchReputation({
    required int userId,
    required int page,
    int pageSize = 30,
  }) async {
    try {
      final response = await apiClient.get(
        "${EndPoints.users}/$userId/${EndPoints.reputationHistory}",
        queryParameters: {
          "page": page,
          "pagesize": pageSize,
          "site": "stackoverflow",
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final items = (data['items'] as List)
            .map((json) => ReputationItem.fromJson(json))
            .toList();

        return Right(items);
      }
      return Left(Failure("Error"));
    } on Failure catch (f) {
      return Left(f);
    }
  }
}
