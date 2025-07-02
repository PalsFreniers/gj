module asset::map{Type};
import std::collections::map;

struct AssetEntry {
        Type data;
        usz refs;
}

alias AssetMap = HashMap {String, AssetEntry};

macro entry(val) {
        AssetEntry e;
        e.data = val;
        e.refs = 1;
        return e;
} 
macro AssetMap.ref(&self, name) => self.get_ref(name)!!.refs++;
macro AssetMap.getRef(&self, name) => self.get_ref(name)!!.refs;
macro AssetMap.unref(&self, name) => self.get_ref(name)!!.refs--;
