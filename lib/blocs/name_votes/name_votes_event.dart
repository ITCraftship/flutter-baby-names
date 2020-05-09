part of 'name_votes_bloc.dart';

abstract class NameVotesEvent extends Equatable {
  const NameVotesEvent();

  @override
  List<Object> get props => [];
}

class LoadNameVotes extends NameVotesEvent {}

class UpdateNameVotes extends NameVotesEvent {
  final List<NameVote> votes;

  UpdateNameVotes(this.votes);

  @override
  List<Object> get props => [votes];
}

class SubmitNameVote extends NameVotesEvent {
  final NameVote vote;

  SubmitNameVote(this.vote);

  @override
  List<Object> get props => [vote];
}

class UpdateUserVotes extends NameVotesEvent {
  final UserVotes votes;

  UpdateUserVotes(this.votes);

  @override
  List<Object> get props => [votes];
}
