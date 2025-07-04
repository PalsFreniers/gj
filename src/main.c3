import engine;
import scenes;

const int[<2>] SCREEN_SIZE = {900, 600};
const float[<2>] GRAVITY = {0, 100};

fn void main() {
        engine::init();
        scene::registerAll();
        engine::setTitle("JUMPER OS");
        engine::setSize(SCREEN_SIZE);
        engine::run();
        engine::cleanup();
}
