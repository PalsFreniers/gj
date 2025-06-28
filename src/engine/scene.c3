module engine::scene;
import std::collections::map;
import engine::gameobject;

alias ObjectMap = Map {String, IGameObject};

struct Scene {
        ObjectMap objs;
        String name;
}

macro new(name) {
        Scene s;
        s.name = name;
        return s;
}

fn void Scene.load(&self) {
        self.objs.@each(k, v) {
                v.init();
        };
}

fn void Scene.unload(&self) {
        self.objs.@each(k, v) {
                v.fini();
        };
}

fn void Scene.set(&self, String name, IGameObject obj) {
        if(catch self.objs[name]) engine::_log.warn("Overriting GameObject Named %s from %s", name, self.name);
        self.objs[name] = obj;
}

fn void Scene.broadcast(&self, Message msg) {
        self.objs.@each(k, v) {
                v.recv(msg);
        };
}

fn void Scene.broadcastExcept(&self, String except, Message msg) {
        self.objs.@each(k, v) {
                if(k != except) v.recv(msg);
        };
}

fn void Scene.send(&self, String name, Message msg) {
        self.objs[name].recv(msg);
}
