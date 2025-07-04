module scenes::editor;
import raylib5;
import scenes;
import engine;
import player;
import main;

fn void checkOutApp() {
        if(rl::isKeyPressed(rl::KEY_ESCAPE)) {
                engine::onUpdate(null);
                engine::gotoScene(scene::DESKTOP);
        }
}

fn Scene setup() {
        Scene s = scene::new("editor");
        os::header(&s);
        Label* wip = label::new("Work In Progress", {0, 0}, size: 100, color: rl::WHITE);
        wip.setPos((float[<2>])main::SCREEN_SIZE / 2 - wip.getSize() / 2);
        wip.setZ(1);
        s["wip"] = wip;
        Player* player = player::new();
        s["player"] = player;
        s.setInitCallback(fn void(Scene* self) => engine::onUpdate(&checkOutApp));
        return s;
}
