import 'dart:async';
import 'dart:math';
import 'package:flame/game.dart';
import 'package:flutter_flame_memory_game/features/flame/components/card_component.dart';
import 'package:flutter_flame_memory_game/features/flame/logic/game_cubit.dart';

class MemoryGame extends FlameGame {
  final GameCubit cubit;

  // Logic variables
  List<CardComponent> cards = [];
  List<CardComponent> selectedCards = [];
  bool isProcessing = false; // Prevent tapping while animating
  StreamSubscription? subscription;

  MemoryGame(this.cubit);

  @override
  Future<void> onLoad() async {
    await initializeGame();

    // Listen to Cubit stream for resets
    subscription = cubit.stream.listen((state) {
      // If the state says playing is true, but our current duration is 0
      // and tries is 0, it means a reset happened.
      if (state.isPlaying && state.currentDuration == 0 && state.tries == 0) {
        initializeGame();
      }
    });
  }

  Future<void> initializeGame() async {
    // Clear existing
    removeAll(children);
    cards.clear();
    selectedCards.clear();
    isProcessing = false;

    // Grid Settings
    const int rows = 4;
    const int cols = 4;
    final double cardWidth = size.x / cols - 10;
    final double cardHeight = size.y / rows - 20;

    // Create pairs (0,0, 1,1, 2,2...)
    List<int> ids = [];
    for (int i = 0; i < (rows * cols) ~/ 2; i++) {
      ids.add(i);
      ids.add(i);
    }
    ids.shuffle(Random());

    // Build Components
    for (int i = 0; i < ids.length; i++) {
      final int row = i ~/ cols;
      final int col = i % cols;

      final card = CardComponent(
        id: ids[i],
        position: Vector2(
            col * cardWidth + (col * 10) + 5,
            row * cardHeight + (row * 10) + 50 // Offset for UI top bar
        ),
        size: Vector2(cardWidth, cardHeight),
        onCardTapped: onCardSelected,
      );

      cards.add(card);
      add(card);
    }

    cubit.startGame();
  }

  void onCardSelected(CardComponent card) {
    if (isProcessing || selectedCards.contains(card)) return;

    card.isRevealed = true;
    selectedCards.add(card);

    if (selectedCards.length == 2) {
      isProcessing = true;
      cubit.incrementTry();
      checkMatch();
    }
  }

  Future<void> checkMatch() async {
    final card1 = selectedCards[0];
    final card2 = selectedCards[1];

    if (card1.id == card2.id) {
      // Match Found
      card1.isMatched = true;
      card2.isMatched = true;
      selectedCards.clear();
      isProcessing = false;

      // Check Win Condition
      if (cards.every((c) => c.isMatched)) {
        if (cards.every((c) => c.isMatched)) {
          cubit.gameWon();
          overlays.add('Victory'); // This shows the widget
        }
      }
    } else {
      // No Match - wait then flip back
      await Future.delayed(const Duration(milliseconds: 1000));
      card1.isRevealed = false;
      card2.isRevealed = false;
      selectedCards.clear();
      isProcessing = false;
    }
  }

  void reset() {
    initializeGame();
  }

  @override
  void onRemove() {
    subscription?.cancel(); // Clean up
    super.onRemove();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (cards.isNotEmpty) {
      layoutCards();
    }
  }

  void layoutCards() {
    const int rows = 4;
    const int cols = 4;
    const double spacing = 10.0;

    // Calculate the available area (leaving room for margins)
    double availableWidth = size.x - (spacing * (cols + 1));
    double availableHeight = size.y - (spacing * (rows + 1));

    // Determine the size of a single card while maintaining a square aspect ratio
    double cardSide = (availableWidth / cols < availableHeight / rows)
        ? availableWidth / cols
        : availableHeight / rows;

    // Center the grid
    double xOffset = (size.x - (cardSide * cols + spacing * (cols - 1))) / 2;
    double yOffset = (size.y - (cardSide * rows + spacing * (rows - 1))) / 2;

    for (int i = 0; i < cards.length; i++) {
      final int row = i ~/ cols;
      final int col = i % cols;

      final newPos = Vector2(
        xOffset + col * (cardSide + spacing),
        yOffset + row * (cardSide + spacing),
      );

      cards[i].updateLayout(Vector2.all(cardSide), newPos);
    }
  }
}