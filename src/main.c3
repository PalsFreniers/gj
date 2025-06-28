import engine;

fn void main() {
        engine::init();
        engine::setTitle("Game");
        engine::setSize({900, 600});
        engine::run();
        engine::cleanup();
}
