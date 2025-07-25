module engine;
import engine::scene;
import engine::logger;
import engine::message;
import raylib5;
import std::collections::list;
import engine::asset;
import scenes;

alias GlobalManager = fn void();
alias CatchMessage = fn void(Message);

Logger _log = "Engine";
AssetManager* _asset = &v_AssetManager;

bool v_Quit @local;
KeyboardKey v_PauseKey @local;
SceneManager v_Manager @local;
GlobalManager v_Update @local;
CatchMessage v_CatchMessage @local;
usz v_CurrentScene @local;
Color v_Background @local;
AssetManager v_AssetManager @local;
bool v_HasShader @local;
Shader v_Shader @local;

fn void init() {
        rl::setTraceLogLevel(TraceLogLevel.NONE);
        rl::initWindow(1, 1, " ");
        rl::setTargetFPS(60);
        setPauseKey(rl::KEY_P);
        setBackgroundColor(rl::BLACK);
        onUpdate(null);
        onMessage(null);
}

fn void run() {
        loadScene(v_CurrentScene);
        while(!v_Quit) {
                if(rl::windowShouldClose() && !rl::isKeyPressed(rl::KEY_ESCAPE)) break;
                if(rl::isKeyPressed(v_PauseKey)) broadcastMessage(PAUSE);
                if(v_Update != null) v_Update();
                v_Manager[v_CurrentScene].update();
                rl::beginDrawing();
                if(v_HasShader) rl::beginShaderMode(v_Shader);
                rl::clearBackground(v_Background);
                v_Manager[v_CurrentScene].draw();
                if(v_HasShader) rl::endShaderMode();
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
macro sendMessage(name, msg, scene = v_CurrentScene) {
        if(name == "engine" && v_CatchMessage != null) { v_CatchMessage(msg);}
        else {v_Manager[scene].send(name, msg);}
}
macro broadcastMessage(msg, scene = v_CurrentScene) {
        if(v_CatchMessage != null) v_CatchMessage(msg);
        v_Manager[scene].broadcast(msg);
}
macro broadcastExceptMessage(name, msg, scene = v_CurrentScene) {
        if(name != "engine" && v_CatchMessage != null) v_CatchMessage(msg);
        v_Manager[scene].broadcastExcept(name, msg);
}
macro onUpdate(f) => v_Update = f;
macro onMessage(f) => v_CatchMessage = f;
macro deltaTime() => rl::getFrameTime();

macro loadScene  (scene) @local {
        v_Manager[scene].load();
        _log.info("loaded scene: %s", v_Manager[scene].name);
}
macro unloadScene(scene) @local => v_Manager[scene].unload();

macro gotoScene(scene) {
        unloadScene(v_CurrentScene);
        v_CurrentScene = scene;
        loadScene(v_CurrentScene);
}

macro setShader(shader) {
        v_HasShader = true;
        v_Shader = shader;
}

macro unsetShader() => v_HasShader = false;

const PAUSE = msg::@new();
alias SceneManager = List {Scene};
