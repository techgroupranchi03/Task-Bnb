import 'package:dio/dio.dart';
import '../../domain/entities/team_member_entity.dart';
import '../../domain/repositories/i_team_repository.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/utils/app_logger.dart';
import '../datasources/team_remote_data_source.dart';

class TeamRepositoryImpl implements ITeamRepository {
  final TeamRemoteDataSource _remote;

  TeamRepositoryImpl({TeamRemoteDataSource? remote})
      : _remote = remote ?? TeamRemoteDataSource();

  @override
  Future<(List<TeamMemberEntity>?, Failure?)> fetchTeamMembers() async {
    try {
      final models = await _remote.fetchTeamMembers();
      return (models.map((m) => m.toEntity()).toList(), null);
    } catch (e, s) {
      return (null, _handleException(e, s, 'TeamRepository.fetchTeamMembers'));
    }
  }

  Failure _handleException(dynamic e, StackTrace s, String context) {
    AppLogger.instance.error(context, e, s);

    if (e is AppException) return _mapException(e);

    if (e is DioException) {
      if (e.error is AppException) return _mapException(e.error as AppException);

      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final message = data['message'] as String? ??
            data['error'] as String? ??
            data['msg'] as String?;
        if (message != null && message.isNotEmpty) {
          return UnknownFailure(message: message);
        }
      }
      if (e.message != null && e.message!.isNotEmpty) {
        return UnknownFailure(message: e.message!);
      }
    }

    return UnknownFailure(message: e.toString());
  }

  Failure _mapException(AppException e) {
    if (e is NetworkException) return NetworkFailure(message: e.message);
    if (e is TimeoutException) return TimeoutFailure(message: e.message);
    if (e is UnauthorizedException) return UnauthorizedFailure(message: e.message);
    if (e is ForbiddenException) return ForbiddenFailure(message: e.message);
    if (e is NotFoundException) return NotFoundFailure(message: e.message);
    if (e is ServerException) return ServerFailure(message: e.message);
    return UnknownFailure(message: e.message);
  }
}
