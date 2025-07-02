import engine;
import player;

const int[<2>] SCREEN_SIZE = {900, 600};

fn Scene scene1Setup() {
        Scene s = scene::new("start");
        s["startLabel"] = label::new("Hello", {200, 200});
        s["player"] = player::newPlayer();
        return s;
}

fn void main() {
        engine::addScene(scene1Setup());
        engine::init();
        engine::setTitle("Game");
        engine::setSize(SCREEN_SIZE);
        engine::run();
        engine::cleanup();
}
