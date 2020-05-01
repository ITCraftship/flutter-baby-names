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
  final String userId;
  final NameVote vote;

  SubmitNameVote(this.userId, this.vote);

  @override
  List<Object> get props => [vote];
}
