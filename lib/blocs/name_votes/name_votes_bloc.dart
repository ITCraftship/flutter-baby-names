import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:name_voter/models/name_vote_model.dart';
import 'package:name_voter/repositories/name_votes/name_votes_repository.dart';

part 'name_votes_event.dart';
part 'name_votes_state.dart';

class NameVotesBloc extends Bloc<NameVotesEvent, NameVotesState> {
  final NameVotesRepository _nameVotesRepository;
  StreamSubscription _votesSubscription;

  NameVotesBloc({@required nameVotesRepository})
      : assert(nameVotesRepository != null),
        _nameVotesRepository = nameVotesRepository;

  @override
  NameVotesState get initialState => NameVotesLoading();

  @override
  Stream<NameVotesState> mapEventToState(
    NameVotesEvent event,
  ) async* {
    if (event is LoadNameVotes) {
      _mapLoadNameVotesToState();
    } else if (event is UpdateNameVotes) {
      yield* _mapUpdateNameVotesToState(event);
    } else if (event is SubmitNameVote) {
      _mapSubmitNameVoteToState(event);
    }
  }

  _mapLoadNameVotesToState() {
    _votesSubscription?.cancel();
    _votesSubscription = _nameVotesRepository
        .all()
        .listen((votes) => add(UpdateNameVotes(votes)));
  }

  _mapSubmitNameVoteToState(SubmitNameVote event) async {
    final NameVotesState currentState = state;
    if (currentState is NameVotesLoaded) {
      final newVotes = currentState.votes.map((vote) {
        if (vote.id == event.vote.id) {
          return vote.copyWith(votes: vote.votes + 1);
        }
        return vote;
      }).toList();
      // TODO: should not make a vote if this user has already given a vote on this name
      add(UpdateNameVotes(newVotes));
      await _nameVotesRepository.recordVote(event.userId, event.vote.id);
    }
  }

  Stream<NameVotesState> _mapUpdateNameVotesToState(
      UpdateNameVotes event) async* {
    yield NameVotesLoaded(event.votes);
  }

  @override
  Future<void> close() {
    _votesSubscription?.cancel();
    return super.close();
  }
}
