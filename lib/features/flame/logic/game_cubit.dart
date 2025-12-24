import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  Timer? _timer;

  GameCubit()
    : super(const GameState(isNewFastest: false, isNewLeastTries: false));

  void startGame() {
    _timer?.cancel();
    emit(state.copyWith(isPlaying: true, currentDuration: 0, tries: 0));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      emit(state.copyWith(currentDuration: state.currentDuration + 1));
    });
  }

  void incrementTry() {
    emit(state.copyWith(tries: state.tries + 1));
  }

  void stopGame() {
    _timer?.cancel();
    emit(state.copyWith(isPlaying: false));
  }

  void resetGame() {
    stopGame();
    startGame();
  }

  // void gameWon() {
  //   _timer?.cancel();
  //
  //   // Calculate High Scores
  //   int? newFastest = state.fastestDuration;
  //   if (state.fastestDuration == null || state.currentDuration < state.fastestDuration!) {
  //     newFastest = state.currentDuration;
  //   }
  //
  //   int? newLeastTries = state.leastTries;
  //   if (state.leastTries == null || state.tries < state.leastTries!) {
  //     newLeastTries = state.tries;
  //   }
  //
  //   emit(state.copyWith(
  //     isPlaying: false,
  //     fastestDuration: newFastest,
  //     leastTries: newLeastTries,
  //   ));
  // }

  void gameWon() {
    _timer?.cancel();

    bool isNewFastest =
        state.fastestDuration == null ||
        state.currentDuration < state.fastestDuration!;
    bool isNewLeastTries =
        state.leastTries == null || state.tries < state.leastTries!;

    emit(
      state.copyWith(
        isPlaying: false,
        fastestDuration: isNewFastest
            ? state.currentDuration
            : state.fastestDuration,
        leastTries: isNewLeastTries ? state.tries : state.leastTries,
        isNewFastest: isNewFastest,
        isNewLeastTries: isNewLeastTries,
      ),
    );
  }
}
