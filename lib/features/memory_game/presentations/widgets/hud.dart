import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flame_memory_game/features/flame/logic/game_cubit.dart';

class HUD extends StatelessWidget {
  const HUD({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameCubit, GameState>(
      listener: (context, state) {
        if (!state.isPlaying && state.tries > 0 && state.currentDuration > 0) {
          // Trigger a reset on the visual game board if the Cubit resets?
          // Since Flame logic is inside the Game class, we need a way to tell the
          // Game instance to reset when the BUTTON is pressed.
          // Note: In this simple architecture, hitting Reset re-initializes the game logic
          // inside the ResetButton handler below by finding the GameWidget or recreating it.
          // For simplicity in this specific snippet, we will handle the Game.reset()
          // via a GlobalKey or by passing a callback.
        }
      },
      builder: (context, state) {
        return Container(
          color: Colors.blueGrey[900],
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatBox(label: "Time", value: "${state.currentDuration}s"),
                  _StatBox(label: "Tries", value: "${state.tries}"),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatBox(
                      label: "Fastest",
                      value: state.fastestDuration == null ? "-" : "${state.fastestDuration}s"
                  ),
                  _StatBox(
                      label: "Least Tries",
                      value: state.leastTries == null ? "-" : "${state.leastTries}"
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (!state.isPlaying && state.tries > 0)
                const Text(
                  "YOU WON!",
                  style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ElevatedButton(
                onPressed: () {
                  // 1. Reset Cubit
                  context.read<GameCubit>().resetGame();

                  // 2. We need to reset the Flame Game.
                  // Because GameWidget holds the instance, a simple way in this
                  // architecture is to force a rebuild or simpler:
                  // The Game class listens to the Cubit stream, OR we just
                  // allow the user to continue playing and the 'Reset' button logic
                  // in a real app would likely use a passed controller.
                  // *Hack for this example:* The GameWidget usually persists.
                  // We will make the MemoryGame listen to the Cubit stream internally?
                  // No, simpler: We will rely on the fact that we passed the Cubit to the Game.
                  // But the Game needs to know "Reset Now".

                  // *Solution:* We will cheat slightly for simplicity:
                  // The reset button here updates the Cubit.
                  // The MemoryGame class doesn't automatically know to regenerate the grid.
                  // Let's fix that in the MemoryGame class below.
                },
                child: const Text("Reset Game"),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}