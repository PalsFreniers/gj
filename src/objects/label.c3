module engine::object::label;
import engine::gameobject;
import engine;
import raylib5;

alias LabelMessageCallback = fn void(Label*, Message);
alias LabelUpdateCallback = fn void(Label*);

struct Label(IGameObject) {
        String text;
        float[<2>] pos;
        String font;
        float size;
        float spacing;
        Color color;
        int z;
        LabelMessageCallback onMessage;
        LabelUpdateCallback onUpdate;
}

macro new(String text, float[<2>] pos, float size = 20, float spacing = 2.5, Color color = rl::RAYWHITE, String font = "default") => mem::new(Label, {
        .text = text,
        .pos = pos,
        .font = font,
        .size = size,
        .spacing = spacing,
        .color = color,
});

fn void Label.init(&self) @dynamic {
        engine::_asset.getFont(self.font);
}

fn void Label.fini(&self) @dynamic {
        engine::_asset.unloadFont(self.font);
}

fn void Label.recv(&self, Message msg) @dynamic {
        if(self.onMessage) self.onMessage(self, msg);
}

fn void Label.setPos(&self, float[<2>] pos) @dynamic => self.pos = pos;
fn float[<2>] Label.getPos(&self) @dynamic => self.pos;
fn float[<2>] Label.getSize(&self) @dynamic {
        Vector2 size = rl::measureTextEx(engine::_asset.getFont(self.font), (ZString)self.text, self.size, self.spacing);
        return {size.x, size.y};
}
fn bool Label.collidable(&self) @dynamic => false;
fn void Label.collide(&self, IGameObject other) @dynamic {}
fn int Label.getZ(&self) @dynamic => self.z;

fn void Label.update(&self) @dynamic {
        if(self.onUpdate) self.onUpdate(self);
}

fn void Label.draw(&self) @dynamic {
        rl::drawTextEx(engine::_asset.getFont(self.font), (ZString)self.text, self.pos.vec2(), self.size, self.spacing, self.color);
}

fn void Label.setUpdateCB(&self, LabelUpdateCallback cb) => self.onUpdate = cb;
fn void Label.setMessageCB(&self, LabelMessageCallback cb) => self.onMessage = cb;
fn void Label.setZ(&self, int z) => self.z = z;
fn void Label.setText(&self, String text) => self.text = text;
