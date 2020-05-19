import 'dart:ui';

import 'package:box2d_flame/box2d.dart' hide Timer;

import 'package:flame/flame.dart';
import 'package:flame/game.dart';

import 'package:flutter/painting.dart';

import 'actors/HorizontalWall.dart';
import 'actors/VerticalWall.dart';
import 'actors/PuckBall.dart';

class AirHockeyGame extends Game implements ContactListener, ContactFilter {
  World world;
  Size screenSize;

  //Components
  PuckBall puckBall;
  HorizontalWall topWall;
  HorizontalWall bottomWall;
  VerticalWall leftWall;
  VerticalWall rightWall;

  //Needed for Box2D
  static const int WORLD_POOL_SIZE = 100;
  static const int WORLD_POOL_CONTAINER_SIZE = 10;
  static const double WORLD_GRID_SCALE = 12;

  AirHockeyGame() {
    world = World.withPool(
      Vector2(0, 0),
      DefaultWorldPool(WORLD_POOL_SIZE, WORLD_POOL_CONTAINER_SIZE),
    );
    world.setContactListener(this);
    world.setContactFilter(this);
    world.setAllowSleep(true);

    initialize();
  }

  //Initialize all things we need, divided by things need the size and things without
  Future initialize() async {
    // Call the resize as soon as flutter is ready
    // Walls
    resize(await Flame.util.initialDimensions());
  }

  void setActors() {
    if (topWall == null) topWall = HorizontalWall(this, Vector2(0, WORLD_GRID_SCALE * -1), WORLD_GRID_SCALE);
    if (bottomWall == null) bottomWall = HorizontalWall(this, Vector2(0, WORLD_GRID_SCALE), WORLD_GRID_SCALE);
    if (leftWall == null) leftWall = VerticalWall(this, Vector2(WORLD_GRID_SCALE / 2 * -1, 0), WORLD_GRID_SCALE * 2);
    if (rightWall == null) rightWall = VerticalWall(this, Vector2(WORLD_GRID_SCALE / 2, 0), WORLD_GRID_SCALE * 2);
    if (puckBall == null) {
      puckBall = PuckBall(this, Vector2(0, 0));
      puckBall.worldBody.applyForce(Vector2(0, WORLD_GRID_SCALE * -1), Vector2(0, WORLD_GRID_SCALE * -1));
    }
  }

  @override
  void render(Canvas canvas) {
    //Setup Background
    Rect bgRect = Rect.fromLTWH(-screenSize.width / 2, -screenSize.height / 2, screenSize.width, screenSize.height);
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xff432132);

    canvas.save();
    canvas.translate(screenSize.width / 2, screenSize.height / 2);
    canvas.scale(screenSize.width / WORLD_GRID_SCALE);
    canvas.drawRect(bgRect, bgPaint);

    //Render components
    puckBall.render(canvas);
    topWall.render(canvas);
    bottomWall.render(canvas);
    leftWall.render(canvas);
    rightWall.render(canvas);

    canvas.restore();
  }

  @override
  void update(double t) {
    world.stepDt(t, 100, 100);

    //Update components
    puckBall.update(t);
    topWall.update(t);
    bottomWall.update(t);
    leftWall.update(t);
    rightWall.update(t);

    world.clearForces();
  }

  @override
  void resize(Size size) {
    screenSize = size;
    setActors();
    //super.resize(size);
  }

  @override
  void beginContact(Contact contact) {
    // TODO: implement beginContact
  }

  @override
  void endContact(Contact contact) {
    // TODO: implement endContact
  }

  @override
  void postSolve(Contact contact, ContactImpulse impulse) {}

  @override
  void preSolve(Contact contact, Manifold oldManifold) {}

  @override
  bool shouldCollide(Fixture fixtureA, Fixture fixtureB) {
    if (fixtureA.userData == 'ball' && fixtureB.userData == 'ball') {
      return false;
    }
    return true;
  }
}
