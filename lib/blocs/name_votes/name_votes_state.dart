part of 'name_votes_bloc.dart';

abstract class NameVotesState extends Equatable {
  const NameVotesState();

  @override
  List<Object> get props => [];
}

class NameVotesLoading extends NameVotesState {}

class NameVotesLoaded extends NameVotesState {
  final List<NameVote> nameVotes;
  final UserVotes userVotes;

  NameVotesLoaded({nameVotes, userVotes})
      : this.nameVotes = nameVotes ?? [],
        this.userVotes = userVotes ?? UserVotes(),
        super();

  @override
  List<Object> get props => [nameVotes, userVotes];
}

class NameVotesNotLoaded extends NameVotesState {}
