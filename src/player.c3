import engine;
import raylib5;
import main;
import std::io;

const float PLAYER_LR_SPEED = 5;
const float PLAYER_JUMP_FORCE = main::GRAVITY.y + PLAYER_LR_SPEED;
const float TERM_VEL = 1;
const float FRICTION = 0.99;

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

fn void Player.recv(&self, Message msg) @dynamic {}

fn void Player.setPos(&self, float[<2>] pos) @dynamic => self.pos = pos;
fn float[<2>] Player.getPos(&self) @dynamic => self.pos;
fn float[<2>] Player.getSize(&self) @dynamic => {self.side, self.side};
fn bool Player.collidable(&self) @dynamic => true;
fn int Player.getZ(&self) @dynamic => 500;

fn void Player.collide(&self, IGameObject other) @dynamic {}

fn void Player.update(&self) @dynamic {
        if(self.pause) return;
        if(self.pos.y >= main::SCREEN_SIZE.y - self.side) {
                if(rl::isKeyPressed(rl::KEY_UP)) self.vel += {0, -PLAYER_JUMP_FORCE};
        }
        if(rl::isKeyDown(rl::KEY_LEFT)) self.vel += {-PLAYER_LR_SPEED, 0};
        if(rl::isKeyDown(rl::KEY_RIGHT)) self.vel += {PLAYER_LR_SPEED, 0};
        self.pos += self.vel * engine::deltaTime();
        self.vel += main::GRAVITY * engine::deltaTime();
        if(self.pos.x < 0) { self.vel.x = 0; self.pos.x = 0; }
        if(self.pos.y < 0) { self.vel.y = 0; self.pos.y = 0; }
        if(self.pos.x > main::SCREEN_SIZE.x - self.side) {
                self.vel.x = 0;
                self.pos.x = main::SCREEN_SIZE.x - self.side;
        }
        if(self.pos.y > main::SCREEN_SIZE.y - self.side) {
                self.vel.y = 0;
                self.pos.y = main::SCREEN_SIZE.y - self.side;
        }
        self.vel *= FRICTION;
}

fn void Player.draw(&self) @dynamic {
        rl::drawRectangleV(self.pos.vec2(), ((float[<2>]){self.side, self.side}).vec2(), rl::GREEN);
}
