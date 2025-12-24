import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flame_memory_game/features/flame/games/memory_game.dart';
import 'package:flutter_flame_memory_game/features/flame/logic/game_cubit.dart';

class VictoryOverlay extends StatelessWidget {
  final MemoryGame game;
  const VictoryOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        return Container(
          color: Colors.black.withOpacity(0.8),
          child: Center(
            child: Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("VICTORY!", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.yellow)),
                    const SizedBox(height: 20),

                    _ScoreRow(
                        label: "Time",
                        value: "${state.currentDuration}s",
                        isPB: state.isNewFastest
                    ),
                    _ScoreRow(
                        label: "Tries",
                        value: "${state.tries}",
                        isPB: state.isNewLeastTries
                    ),

                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                      onPressed: () {
                        context.read<GameCubit>().resetGame();
                        game.overlays.remove('Victory');
                      },
                      child: const Text("PLAY AGAIN", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ScoreRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isPB;

  const _ScoreRow({required this.label, required this.value, required this.isPB});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("$label: $value", style: const TextStyle(fontSize: 20, color: Colors.white)),
          if (isPB) ...[
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(4)),
              child: const Text("NEW BEST!", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            )
          ]
        ],
      ),
    );
  }
}