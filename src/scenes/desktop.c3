module scenes::desktop;
import std::core::dstring;
import appicon;
import raylib5;
import scenes;
import engine;
import main;

Shader red;
Shader green;
Shader blue;

bool v_quit;

fn void redLevel(AppIcon* self) {
        engine::setShader(red);
}

fn void greenLevel(AppIcon* self) {
        engine::setShader(green);
}

fn void blueLevel(AppIcon* self) {
        engine::setShader(blue);
}

fn void tmpEndShader() {
        if(rl::isKeyPressed(rl::KEY_ESCAPE)) engine::unsetShader();
}

fn Scene setup() {
        Scene s = scene::new("OS");
        os::header(&s);
        AppIcon* noteIcon = appicon::new("Memo", {100, 100}, {75, 75}, "note.png", rl::WHITE);
        noteIcon.setOnClick(fn void(AppIcon* icon) => engine::gotoScene(scene::MEMO));
        s["noteIcon"] = noteIcon;
        AppIcon* redIcon = appicon::new("Red", {225, 100}, {75, 75}, "level.png", rl::RED);
        redIcon.setOnClick(&redLevel);
        s["redIcon"] = redIcon;
        AppIcon* greenIcon = appicon::new("Green", {350, 100}, {75, 75}, "level.png", rl::GREEN);
        greenIcon.setOnClick(&greenLevel);
        s["greenIcon"] = greenIcon;
        AppIcon* blueIcon = appicon::new("Blue", {475, 100}, {75, 75}, "level.png", rl::BLUE);
        blueIcon.setOnClick(&blueLevel);
        s["blueIcon"] = blueIcon;
        AppIcon* levelEditorIcon = appicon::new("Editor", {700, 400}, {75, 75}, "work.png", rl::WHITE);
        levelEditorIcon.setOnClick(fn void(AppIcon* self) => engine::gotoScene(scene::EDITOR));
        s["editorIcon"] = levelEditorIcon;
        AppIcon* quitIcon = appicon::new("Quit", {400, 400}, {75, 75}, "quit.png", rl::WHITE);
        quitIcon.setOnClick(fn void(AppIcon* self) => engine::gotoScene(scene::QUIT));
        s["quitIcon"] = quitIcon;
        s.setInitCallback(fn void(Scene* self) => engine::onUpdate(&tmpEndShader));
        red = engine::_asset.getShader("red");
        green = engine::_asset.getShader("green");
        blue = engine::_asset.getShader("blue");
        return s;
}
