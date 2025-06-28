module engine;
import engine::scene;
import engine::logger;
import raylib5;
import std::collections::list;

Logger _log = "Engine";

bool v_Quit @local;

fn void init() {
        rl::setTraceLogLevel(7);
        rl::initWindow(1, 1, " ");
}

fn void run() {
        while(!v_Quit) {
                if(rl::windowShouldClose() && !rl::isKeyPressed(rl::KEY_ESCAPE)) break;
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

module engine::message::msg;

alias Message = usz;

Message v_Msg @local;

macro newMsg() => v_Msg++;

const STOP = newMsg();
