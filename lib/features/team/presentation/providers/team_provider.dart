import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/team_member_entity.dart';
import '../../domain/usecases/fetch_team_members_usecase.dart';
import '../../data/repositories/team_repository_impl.dart';
import '../../../../core/error/failure.dart';

// ── State ────────────────────────────────────────────────────────────────────
class TeamState {
  final bool isLoading;
  final List<TeamMemberEntity> members;
  final Failure? failure;

  const TeamState({
    this.isLoading = false,
    this.members = const [],
    this.failure,
  });

  TeamState copyWith({
    bool? isLoading,
    List<TeamMemberEntity>? members,
    Failure? failure,
    bool clearFailure = false,
  }) =>
      TeamState(
        isLoading: isLoading ?? this.isLoading,
        members: members ?? this.members,
        failure: clearFailure ? null : failure ?? this.failure,
      );
}

// ── Notifier ─────────────────────────────────────────────────────────────────
class TeamNotifier extends StateNotifier<TeamState> {
  late final FetchTeamMembersUsecase _fetchUsecase;

  TeamNotifier() : super(const TeamState()) {
    final repo = TeamRepositoryImpl();
    _fetchUsecase = FetchTeamMembersUsecase(repo);
    fetchTeamMembers();
  }

  Future<void> fetchTeamMembers() async {
    state = state.copyWith(isLoading: true, clearFailure: true);
    final (members, failure) = await _fetchUsecase();
    if (failure != null) {
      state = state.copyWith(isLoading: false, failure: failure);
    } else {
      state = state.copyWith(isLoading: false, members: members ?? []);
    }
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────
final teamProvider = StateNotifierProvider<TeamNotifier, TeamState>(
  (ref) => TeamNotifier(),
);
