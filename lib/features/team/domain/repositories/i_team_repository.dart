import '../../../../core/error/failure.dart';
import '../entities/team_member_entity.dart';

abstract class ITeamRepository {
  Future<(List<TeamMemberEntity>?, Failure?)> fetchTeamMembers();
}
