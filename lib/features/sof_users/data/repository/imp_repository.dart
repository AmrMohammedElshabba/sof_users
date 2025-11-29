import 'dart:convert';

import 'package:sof_users/core/network/api_client.dart';
import 'package:sof_users/core/utilities/endpoints.dart';
import 'package:sof_users/features/sof_users/domain/models/sof_user.dart';
import 'package:sof_users/features/sof_users/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';

class GetSOFUsersImpRepo implements GetSOFUsersRepo {
  final ApiClient apiClient;

  GetSOFUsersImpRepo({required this.apiClient});

  @override
  Future<Either<Failure, List<SOFUser>>> fetchUsers({
    required int page,
    int pageSize = 30,
  }) async {
    try {
      final response = await apiClient.get(
        EndPoints.users,
        queryParameters: {
          "page": page,
          "pagesize": pageSize,
          "order": "desc",
          "sort": "reputation",
          "site": "stackoverflow",
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final items = (data['items'] as List)
            .map((json) => SOFUser.fromJson(json))
            .toList();

        return Right(items);
      }
      return Left(Failure("Error"));
    } on Failure catch (f) {
      return Left(f);
    }
  }
}
