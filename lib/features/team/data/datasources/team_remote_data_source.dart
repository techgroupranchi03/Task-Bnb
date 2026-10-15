import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/team_member_model.dart';

class TeamRemoteDataSource {
  final DioClient _client;

  TeamRemoteDataSource({DioClient? client})
      : _client = client ?? DioClient.instance;

  Future<List<TeamMemberModel>> fetchTeamMembers() async {
    final response = await _client.get(ApiEndpoints.clientTeam);

    final body = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : <String, dynamic>{};

    final dataList = body['data'];
    if (dataList is! List) return [];

    return dataList
        .whereType<Map<String, dynamic>>()
        .map(TeamMemberModel.fromJson)
        .toList();
  }
}
