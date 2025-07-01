module engine;
import engine::scene;
import engine::logger;
import engine::message;
import raylib5;
import std::collections::list;

Logger _log = "Engine";

bool v_Quit @local;
KeyboardKey v_PauseKey @local;
test

fn void init() {
        rl::setTraceLogLevel(7);
        rl::initWindow(1, 1, " ");
		setPauseKey(rl::KEY_P);
}

fn void run() {
        while(!v_Quit) {
                if(rl::windowShouldClose() && !rl::isKeyPressed(rl::KEY_ESCAPE)) break;
				if(rl::isKeyPressed(keyPause))
        }
}

fn void cleanup() {
        rl::closeWindow();
}

macro setTitle(String $title) {
        _log = $title;
        rl::setWindowTitle($title);
}

macro setSize(int[<2>] $size) => rl::setWindowSize($size.x, $size.y);
macro fullscreen() => rl::toggleFullscreen();
macro quit() => v_Quit = true;
macro setPauseKey(key) => v_PauseKey = key;
macro addScene(scene) => v_Manager.scenes.append(scene);

const PAUSE = msg::@new();
alias SceneManager = List {Scene};
