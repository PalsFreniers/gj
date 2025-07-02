module engine::scene;
import std::collections::map;
import engine::gameobject;
import engine::message;

alias ObjectMap = HashMap {String, IGameObject};

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
        self.objs.@each(; String k, IGameObject v) {
                v.init();
        };
}

fn void Scene.unload(&self) {
        self.objs.@each(; String k, IGameObject v) {
                v.fini();
        };
}

fn void Scene.set(&self, String name, IGameObject obj) @operator([]=) {
        if(try self.objs[name]) engine::_log.warn("Overriting GameObject Named %s from %s", name, self.name);
        self.objs[name] = obj;
}

fn void Scene.broadcast(&self, Message msg) {
        self.objs.@each(; String k, IGameObject v) {
                v.recv(msg);
        };
}

fn void Scene.broadcastExcept(&self, String except, Message msg) {
        self.objs.@each(; String k, IGameObject v) {
                if(k != except) v.recv(msg);
        };
}

fn void Scene.update(&self) {
	self.objs.@each(; String k, IGameObject v) {
		v.update();
	};
}

fn void Scene.draw(&self) {
	self.objs.@each(; String k, IGameObject v) {
		v.draw();
	};
}

fn void Scene.send(&self, String name, Message msg) {
        IGameObject? obj = self.objs[name];
        if(catch obj) return;
        obj.recv(msg);
}
