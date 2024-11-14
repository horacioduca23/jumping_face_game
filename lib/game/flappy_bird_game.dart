import 'dart:async';
import 'dart:typed_data';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame_mini_game/components/background.dart';
import 'package:flutter_flame_mini_game/components/clouds.dart';
import 'package:flutter_flame_mini_game/components/ground.dart';
import 'package:flutter_flame_mini_game/components/pipe_group.dart';

import '../components/player.dart';
import 'configuration.dart';
import 'player_movement.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Player player;
  bool isHit = false;
  late TextComponent score;

  final Timer interval = Timer(
    //CUIDADO CON EL IMPORT DEL PACKAGE != del de flutter
    Config.pipeInterval,
    repeat: true,
  );

  @override
  Future<void> onLoad() async {
    addAll(
      [
        Background(),
        Ground(),
        Clouds(),
        player = Player(),
        score = buildScore(),
      ],
    );

    interval.onTick = () => add(
          PipeGroup(),
        );
  }

  Future<void> loadCustomSprite({required Uint8List bytes}) async {
    // Carga la imagen desde los bytes y crea el sprite
    final image = await decodeImageFromList(bytes);
    final customSprite = Sprite(image);

    // Asigna el sprite personalizado en todas las direcciones de movimiento
    player.sprites = {
      PlayerMovement.middle: customSprite,
      PlayerMovement.up: customSprite,
      PlayerMovement.down: customSprite,
    };
  }

  TextComponent buildScore() => TextComponent(
        text: 'Score: 0',
        position: Vector2(size.x / 2, size.y / 2 * 0.2),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Game',
          ),
        ),
      );

  @override
  void onTap() {
    super.onTap();
    player.fly();
  }

  @override
  void update(double dt) {
    super.update(dt);
    interval.update(dt);

    score.text = 'Score: ${player.score}';
  }
}
