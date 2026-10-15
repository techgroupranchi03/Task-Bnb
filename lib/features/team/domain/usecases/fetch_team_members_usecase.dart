import '../../../../core/error/failure.dart';
import '../entities/team_member_entity.dart';
import '../repositories/i_team_repository.dart';

class FetchTeamMembersUsecase {
  final ITeamRepository _repository;

  const FetchTeamMembersUsecase(this._repository);

  Future<(List<TeamMemberEntity>?, Failure?)> call() =>
      _repository.fetchTeamMembers();
}
