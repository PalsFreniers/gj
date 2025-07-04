import engine::gameobject;
import engine;
import raylib5;

alias AppIconMessageCallback = fn void(AppIcon*, Message);
alias AppIconClickCallback = fn void(AppIcon*);

struct AppIcon(IGameObject) {
        float[<2>] pos;
        float[<2>] size;
        Color color;
        String texture;
        String name;
        int z;
        bool highlight;
        AppIconMessageCallback onMessage;
        AppIconClickCallback onClick;
}

macro new(String name, float[<2>] pos, float[<2>] size, String texture, Color color) => mem::new(AppIcon, {
        .name = name,
        .pos = pos,
        .size = size,
        .color = color,
        .texture = texture,
});

fn void AppIcon.init(&self) @dynamic {
        engine::_asset.getTexture(self.texture);
}

fn void AppIcon.fini(&self) @dynamic {
        engine::_asset.unloadTexture(self.texture);
}

fn void AppIcon.recv(&self, Message msg) @dynamic {
        if(self.onMessage) self.onMessage(self, msg);
}

fn void AppIcon.setPos(&self, float[<2>] pos) @dynamic => self.pos = pos;
fn float[<2>] AppIcon.getPos(&self) @dynamic => self.pos;
fn float[<2>] AppIcon.getSize(&self) @dynamic => self.size;
fn bool AppIcon.collidable(&self) @dynamic => false;
fn void AppIcon.collide(&self, IGameObject other) @dynamic {}
fn int AppIcon.getZ(&self) @dynamic => self.z;

fn void AppIcon.update(&self) @dynamic {
        Vector2 mouse = rl::getMousePosition();
        self.highlight = false;
        if(mouse.x > self.pos.x && mouse.x <= self.pos.x + self.size.x
        && mouse.y > self.pos.y && mouse.y <= self.pos.y + self.size.y) {
                self.highlight = true;
                if(rl::isMouseButtonPressed(MouseButton.LEFT) && self.onClick != null) self.onClick(self); 
        }
}

fn void AppIcon.draw(&self) @dynamic {
        Vector2 textSize = rl::measureTextEx(engine::_asset.getFont("default"), (ZString)self.name, 10, 2);
        if(self.highlight) rl::drawRectangleV((self.pos - 10).vec2(), (self.size + (float[<2>]){0, textSize.y + 10} + 20).vec2(), rl::YELLOW);
        rl::drawRectangleV(self.pos.vec2(), (self.size + (float[<2>]){0, textSize.y + 10}).vec2(), self.color);
        rl::drawTextEx(engine::_asset.getFont("default"), (ZString)self.name, (self.pos + 5).vec2(), 10, 2, rl::BLACK);
        Texture2D tex = engine::_asset.getTexture(self.texture);
        Rectangle src = (Rectangle){
                .x = 0,
                .y = 0,
                .width = tex.width,
                .height = tex.height,
        };
        rl::drawTexturePro(tex, src, (Rectangle){self.pos.x, self.pos.y + textSize.y + 10, self.size.x, self.size.y}, ((float[<2>]){0, 0}).vec2(), 0, self.color);
}

fn void AppIcon.setMessageCB(&self, AppIconMessageCallback cb) => self.onMessage = cb;
fn void AppIcon.setOnClick(&self, AppIconClickCallback cb) => self.onClick = cb;
fn void AppIcon.setZ(&self, int z) => self.z = z;
