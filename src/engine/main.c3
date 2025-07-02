module engine;
import engine::scene;
import engine::logger;
import engine::message;
import raylib5;
import std::collections::list;
import engine::asset;

alias GlobalManager = fn void();

Logger _log = "Engine";
AssetManager* _asset = &v_AssetManager;

bool v_Quit @local;
KeyboardKey v_PauseKey @local;
SceneManager v_Manager @local;
GlobalManager v_Update @local;
usz v_CurrentScene @local;
Color v_Background @local;
AssetManager v_AssetManager @local;

fn void init() {
        rl::setTraceLogLevel(TraceLogLevel.NONE);
        rl::initWindow(1, 1, " ");
        setPauseKey(rl::KEY_P);
        setBackgroundColor(rl::BLACK);
        onUpdate(null);
        v_AssetManager.init();
        loadScene(v_CurrentScene);
}

fn void run() {
        while(!v_Quit) {
                if(rl::windowShouldClose() && !rl::isKeyPressed(rl::KEY_ESCAPE)) break;
                if(rl::isKeyPressed(v_PauseKey)) broadcastMessage(PAUSE);
                if(v_Update != null) v_Update();
                v_Manager[v_CurrentScene].update();
                rl::beginDrawing();
                rl::clearBackground(v_Background);
                v_Manager[v_CurrentScene].draw();
                rl::endDrawing();
        }
}

fn void cleanup() {
        unloadScene(v_CurrentScene);
        rl::closeWindow();
}

macro setTitle(String $title) {
        _log = $title;
        rl::setWindowTitle($title);
}

macro setSize(int[<2>] $size) => rl::setWindowSize($size.x, $size.y);
macro setPauseKey(key) => v_PauseKey = key;
macro setBackgroundColor(color) => v_Background = color;
macro fullscreen() => rl::toggleFullscreen();
macro quit() => v_Quit = true;
macro addScene(scene) => v_Manager.push(scene);
macro sendMessage(name, msg, scene = v_CurrentScene) => v_Manager[scene].send(name, msg);
macro broadcastMessage(msg, scene = v_CurrentScene) => v_Manager[scene].broadcast(msg);
macro broadcastExceptMessage(name, msg, scene = v_CurrentScene) => v_Manager[scene].broadcastExcept(name, msg);
macro onUpdate(f) => v_Update = f;
macro deltaTime() => rl::getFrameTime();

macro loadScene  (scene) @local => v_Manager[scene].load();
macro unloadScene(scene) @local => v_Manager[scene].unload();

macro gotoScene(scene) {
        unloadScene(v_CurrentScene);
        v_CurrentScene = scene;
        loadScene(v_CurrentScene);
}

const PAUSE = msg::@new();
alias SceneManager = List {Scene};
