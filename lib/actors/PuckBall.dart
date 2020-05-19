import 'dart:ui';

import 'package:box2d_flame/box2d.dart' hide Timer;
import 'package:airhockey/AirHockeyGame.dart';

class PuckBall {
  final AirHockeyGame game;

  Body worldBody;
  CircleShape shape;
  Paint paint;
  double radius = .25;

  //Initial acceleration -> no movement as its (0,0)
  //Vector2 acceleration = Vector2(0, 1);

  PuckBall(this.game, Vector2 position) {
    //Shape
    shape = CircleShape();
    shape.p.setFrom(Vector2(0, 0));
    shape.radius = radius;

    //Color
    paint = Paint();
    paint.color = Color(0xffffffff);

    BodyDef actorBodyDef = BodyDef();
    //actorBodyDef.linearVelocity = new Vector2(1, 1);
    actorBodyDef.position = position;
    actorBodyDef.fixedRotation = true;
    actorBodyDef.bullet = false;
    actorBodyDef.type = BodyType.DYNAMIC;


    //WE add the body to the world
    worldBody = game.world.createBody(actorBodyDef);
    worldBody.userData = this;

    FixtureDef fixtureDef = FixtureDef();
    fixtureDef.density = 1.0;
    fixtureDef.restitution = 0.8;
    fixtureDef.friction = 0;
    fixtureDef.shape = shape;
    
    Fixture bodyFixture = worldBody.createFixtureFromFixtureDef(fixtureDef);
    bodyFixture.userData = 'ball';
  }

  void render(Canvas c) {
    c.save();
    //Move the canvas point 0,0 to the top left edge of our ball
    c.translate(worldBody.position.x, worldBody.position.y);
    //Simply draw the circle
    c.drawCircle(Offset(0, 0), radius, paint);
    c.restore();
  }

  void update(double t) {



  }
}
