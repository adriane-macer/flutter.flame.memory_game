part of 'game_cubit.dart';

// --- STATES ---
class GameState extends Equatable {
  final int currentDuration; // in seconds
  final int? fastestDuration;
  final int tries;
  final int? leastTries;
  final bool isPlaying;
  final bool isNewFastest;
  final bool isNewLeastTries;

  const GameState({
    this.currentDuration = 0,
    this.fastestDuration,
    this.tries = 0,
    this.leastTries,
    this.isPlaying = false,
    required this.isNewFastest,
    required this.isNewLeastTries,
  });

  GameState copyWith({
    int? currentDuration,
    int? fastestDuration,
    int? tries,
    int? leastTries,
    bool? isPlaying,
    bool? isNewFastest,
    bool? isNewLeastTries,
  }) {
    return GameState(
      currentDuration: currentDuration ?? this.currentDuration,
      fastestDuration: fastestDuration ?? this.fastestDuration,
      tries: tries ?? this.tries,
      leastTries: leastTries ?? this.leastTries,
      isPlaying: isPlaying ?? this.isPlaying,
      isNewFastest: isNewFastest ?? this.isNewFastest,
      isNewLeastTries: isNewLeastTries ?? this.isNewLeastTries,
    );
  }

  @override
  List<Object?> get props => [
    currentDuration,
    fastestDuration,
    tries,
    leastTries,
    isPlaying,
    isNewFastest,
    isNewLeastTries,
  ];
}
