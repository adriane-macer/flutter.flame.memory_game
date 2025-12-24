import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flame_memory_game/features/flame/games/memory_game.dart';
import 'package:flutter_flame_memory_game/features/flame/logic/game_cubit.dart';
import 'package:flutter_flame_memory_game/features/memory_game/presentations/widgets/hud.dart';
import 'package:flutter_flame_memory_game/features/memory_game/presentations/widgets/victory_overlay.dart';

class MemoryGamePage extends StatelessWidget {
  const MemoryGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameCubit(),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            constraints: BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                // --- HUD / Scoreboard ---
                const HUD(),
                // --- Game Area ---
                Expanded(
                  child: Builder(
                    builder: (context) {
                      return GameWidget(
                        game: MemoryGame(context.read<GameCubit>()),
                        overlayBuilderMap: {
                          'Victory': (context, MemoryGame game) =>
                              VictoryOverlay(game: game),
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
