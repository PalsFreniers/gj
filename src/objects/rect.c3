module engine::object::rect;
import engine::gameobject;
import engine;
import raylib5;

alias RectMessageCallback = fn void(Rect*, Message);
alias RectUpdateCallback = fn void(Rect*);

struct Rect(IGameObject) {
        float[<2>] pos;
        float[<2>] size;
        Color color;
        bool col;
        int z;
        RectMessageCallback onMessage;
        RectUpdateCallback onUpdate;
}

macro new(float[<2>] pos, float[<2>] size, Color color) => mem::new(Rect, {
        .pos = pos,
        .size = size,
        .color = color,
});

fn void Rect.init(&self) @dynamic {}

fn void Rect.fini(&self) @dynamic {}

fn void Rect.recv(&self, Message msg) @dynamic {
        if(self.onMessage) self.onMessage(self, msg);
}

fn void Rect.setPos(&self, float[<2>] pos) @dynamic => self.pos = pos;
fn float[<2>] Rect.getPos(&self) @dynamic => self.pos;
fn float[<2>] Rect.getSize(&self) @dynamic => self.size;
fn bool Rect.collidable(&self) @dynamic => self.col;
fn void Rect.collide(&self, IGameObject other) @dynamic {}
fn int Rect.getZ(&self) @dynamic => self.z;

fn void Rect.update(&self) @dynamic {
        if(self.onUpdate) self.onUpdate(self);
}

fn void Rect.draw(&self) @dynamic {
        rl::drawRectangleV(self.pos.vec2(), self.size.vec2(), self.color);
}

fn void Rect.setUpdateCB(&self, RectUpdateCallback cb) => self.onUpdate = cb;
fn void Rect.setMessageCB(&self, RectMessageCallback cb) => self.onMessage = cb;
fn void Rect.resetCollide(&self) => self.col = true;
fn void Rect.setCollide(&self, bool col) => self.col = col;
fn void Rect.unsetCollide(&self) => self.col = false;
fn void Rect.setZ(&self, int z) => self.z = z;
