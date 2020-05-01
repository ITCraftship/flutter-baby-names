part of 'name_votes_bloc.dart';

abstract class NameVotesState extends Equatable {
  const NameVotesState();

  @override
  List<Object> get props => [];
}

class NameVotesLoading extends NameVotesState {}

class NameVotesLoaded extends NameVotesState {
  final List<NameVote> votes;
  NameVotesLoaded(this.votes) : super();

  @override
  List<Object> get props => [votes];
}

class NameVotesNotLoaded extends NameVotesState {}
