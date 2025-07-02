import engine;
import raylib5;
import main;
import std::io;

const PLAYER_SPEED = 0.5;
const TERM_VEL = 1;
const FRICTION = 0.9999;

struct Player(IGameObject) {
        float[<2>] pos;
        float[<2>] vel;
        float side;
        bool pause;
}

macro newPlayer() => mem::new(Player, {
        .pos = main::SCREEN_SIZE / 2 + 20,
        .vel = {0, 0},
        .side = 40,
});

fn void Player.init(&self) @dynamic {}
fn void Player.fini(&self) @dynamic {}

fn void Player.recv(&self, Message msg) @dynamic {
        if(msg == engine::PAUSE) self.pause = !self.pause;
}

fn void Player.setPos(&self, float[<2>] pos) @dynamic {
        self.pos = pos;
}

fn float[<2>] Player.getPos(&self) @dynamic {
        return self.pos;
}

fn void Player.update(&self) @dynamic {
        if(self.pause) return;
        if(rl::isKeyDown(rl::KEY_UP)) self.vel += {0, -PLAYER_SPEED};
        if(rl::isKeyDown(rl::KEY_DOWN)) self.vel += {0, PLAYER_SPEED};
        if(rl::isKeyDown(rl::KEY_LEFT)) self.vel += {-PLAYER_SPEED, 0};
        if(rl::isKeyDown(rl::KEY_RIGHT)) self.vel += {PLAYER_SPEED, 0};
        self.pos += self.vel * engine::deltaTime();
        if(self.pos.x < 0) { self.vel.x = -self.vel.x; self.pos.x = 0; }
        if(self.pos.y < 0) { self.vel.y = -self.vel.y; self.pos.y = 0; }
        if(self.pos.x > main::SCREEN_SIZE.x - self.side) { self.vel.x = -self.vel.x; self.pos.x = main::SCREEN_SIZE.x - self.side; }
        if(self.pos.y > main::SCREEN_SIZE.y - self.side) { self.vel.y = -self.vel.y; self.pos.y = main::SCREEN_SIZE.y - self.side; }
        self.vel *= FRICTION;
}

fn void Player.draw(&self) @dynamic {
        rl::drawRectangleV(self.pos.vec2(), ((float[<2>]){self.side, self.side}).vec2(), rl::GREEN);
}
