import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class CardComponent extends PositionComponent with TapCallbacks {
  final int id; // The logic ID (e.g., 0-7 for 8 pairs)
  final Function(CardComponent) onCardTapped;

  bool isRevealed = false;
  bool isMatched = false;

  late TextComponent _textComponent;
  late RectangleComponent _backRequest;
  late RectangleComponent _frontRequest;

  CardComponent({
    required this.id,
    required this.onCardTapped,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    // Card Back (Hidden) - Grey
    _backRequest = RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.blueGrey,
    );

    // Card Front (Revealed) - White background
    _frontRequest = RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.white,
    );

    // The Number/Symbol on the card
    _textComponent = TextComponent(
      text: '$id',
      textRenderer: TextPaint(
        style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    )..anchor = Anchor.center
      ..position = size / 2;

    add(_backRequest);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Simple state rendering logic
    if (isRevealed || isMatched) {
      if (!contains(_frontRequest)) add(_frontRequest);
      if (!contains(_textComponent)) add(_textComponent);
      if (contains(_backRequest)) remove(_backRequest);
    } else {
      if (!contains(_backRequest)) add(_backRequest);
      if (contains(_frontRequest)) remove(_frontRequest);
      if (contains(_textComponent)) remove(_textComponent);
    }

    // Dim the card if matched
    if (isMatched) {
      _frontRequest.paint.color = Colors.green.withAlpha(155);
    } else {
      _frontRequest.paint.color = Colors.white;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!isRevealed && !isMatched) {
      onCardTapped(this);
    }
  }

  void reset() {
    isRevealed = false;
    isMatched = false;
  }

  void updateLayout(Vector2 newSize, Vector2 newPosition) {
    size = newSize;
    position = newPosition;

    // Update children positions
    _backRequest.size = size;
    _frontRequest.size = size;
    _textComponent.position = size / 2;
  }
}