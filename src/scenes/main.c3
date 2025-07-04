module scenes::scene;
import scenes;
import engine;

const int LOGO    = 0;
const int DESKTOP = 1;
const int MEMO    = 2;
const int EDITOR  = 3;
const int QUIT    = 4;

fn void registerAll() {
        engine::addScene(logo::setup());
        engine::addScene(desktop::setup());
        engine::addScene(memo::setup());
        engine::addScene(editor::setup());
        engine::addScene(quit::setup());
}
