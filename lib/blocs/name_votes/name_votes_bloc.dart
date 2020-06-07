import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:name_voter/models/name_vote_model.dart';
import 'package:name_voter/models/user_votes.dart';
import 'package:name_voter/repositories/name_votes/name_votes_repository.dart';

part 'name_votes_event.dart';
part 'name_votes_state.dart';

// for simplicity I've mixed the responsibility of this block and using it for both NameVotes and UserVotes
// in a production app I'd rather split them up similarily to:
// https://github.com/felangel/bloc/blob/master/examples/flutter_firestore_todos/lib/blocs/filtered_todos/filtered_todos_bloc.dart
class NameVotesBloc extends Bloc<NameVotesEvent, NameVotesState> {
  final NameVotesRepository _nameVotesRepository;
  StreamSubscription _votesSubscription;
  StreamSubscription _userVotesSubscription;

  NameVotesBloc({@required NameVotesRepository nameVotesRepository})
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
    } else if (event is UpdateUserVotes) {
      yield* _mapUpdateUserVotesToState(event);
    } else if (event is SubmitNameVote) {
      _mapSubmitNameVoteToState(event);
    } else if (event is WithdrawNameVote) {
      _mapWithdrawNameVoteToState(event);
    }
  }

  void _mapLoadNameVotesToState() {
    _votesSubscription?.cancel();
    _votesSubscription = _nameVotesRepository
        .all()
        .listen((votes) => add(UpdateNameVotes(votes)));
    _userVotesSubscription?.cancel();
    _userVotesSubscription = _nameVotesRepository
        .my()
        .listen((votes) => add(UpdateUserVotes(votes)));
  }

  // submitting a vote should be in UserVotesBloc and it would call add on NameVotes
  // only if a vote hasn't already been submitted
  Future<void> _mapSubmitNameVoteToState(SubmitNameVote event) async {
    if (state is! NameVotesLoaded) {
      return;
    }

    final NameVotesLoaded currentState = state as NameVotesLoaded;

    // makes a vote if this user has not already given a vote on this name
    // this will refresh the UI immediately and then eventually refresh the UI when another user
    // voted on the same name because of the listener created in _mapLoadNameVotesToState()
    if (!currentState.userVotes.hasVote(event.vote.id)) {
      if (currentState.nameVotes.any((vote) => vote.id == event.vote.id)) {
        final newVotes = currentState.nameVotes.map((vote) {
          if (vote.id == event.vote.id) {
            return vote.copyWith(votes: vote.votes + 1);
          }
          return vote;
        }).toList();

        add(UpdateNameVotes(newVotes));
      } else {
        final newVotes = [...currentState.nameVotes, event.vote];
        newVotes.sort((a, b) => a.id.compareTo(b.id));
        add(UpdateNameVotes(newVotes));
      }

      add(UpdateUserVotes(UserVotes.fromSet(
          {...currentState.userVotes.votedNames, event.vote.id})));
    }

    // but still writing to the repository in case another device has deleted the vote
    // Firestore hook
    await _nameVotesRepository.recordVote(event.vote.id);
  }

  Future<void> _mapWithdrawNameVoteToState(WithdrawNameVote event) async {
    if (state is! NameVotesLoaded) {
      return;
    }

    final NameVotesLoaded currentState = state as NameVotesLoaded;

    if (!currentState.userVotes.hasVote(event.vote.id)) {
      return;
    }
    final newNameVotes = currentState.nameVotes.map((element) {
      if (element.id != event.vote.id) {
        return element;
      } else {
        return element.copyWith(votes: element.votes - 1);
      }
    }).toList();
    add(UpdateNameVotes(newNameVotes));
    final newUserVotes = currentState.userVotes.copyWithout(event.vote.id);
    add(UpdateUserVotes(newUserVotes));

    await _nameVotesRepository.withdrawVote(event.vote.id);
  }

  Stream<NameVotesState> _mapUpdateNameVotesToState(
      UpdateNameVotes event) async* {
    if (state is! NameVotesLoaded) {
      yield NameVotesLoaded(nameVotes: event.votes);
      return;
    }
    final NameVotesLoaded currentState = state as NameVotesLoaded;
    yield NameVotesLoaded(
        nameVotes: event.votes, userVotes: currentState.userVotes);
  }

  Stream<NameVotesState> _mapUpdateUserVotesToState(
      UpdateUserVotes event) async* {
    if (state is! NameVotesLoaded) {
      yield NameVotesLoaded(userVotes: event.votes);
      return;
    }
    final NameVotesLoaded currentState = state as NameVotesLoaded;
    yield NameVotesLoaded(
        userVotes: event.votes, nameVotes: currentState.nameVotes);
  }

  @override
  Future<void> close() {
    _votesSubscription?.cancel();
    _userVotesSubscription?.cancel();
    return super.close();
  }
}
