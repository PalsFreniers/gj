module engine::scene;
import std::collections::map;
import std::collections::list;
import engine::gameobject;
import engine::message;
import std::sort;

alias ObjectMap = HashMap {String, IGameObject};
alias InitCallback = fn void(Scene*);

struct Scene {
        ObjectMap objs;
        String name;
        InitCallback initCB;
}

macro new(name) {
        Scene s;
        s.name = name;
        return s;
}

fn void Scene.setInitCallback(&self, InitCallback cb) => self.initCB = cb;

fn void Scene.load(&self) {
        if(self.initCB != null) self.initCB(self);
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
        List {IGameObject} objs;
	self.objs.@each(; String k, IGameObject v) {
                objs.push(v);
	};
        sort::quicksort(objs, fn int(IGameObject a, IGameObject b) => a.getZ() - b.getZ());
        foreach(obj: objs) {
                obj.draw();
        }
        objs.free();
}

fn void Scene.send(&self, String name, Message msg) {
        IGameObject? obj = self.objs[name];
        if(catch obj) return;
        obj.recv(msg);
}
