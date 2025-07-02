module engine::asset;
import asset;
import raylib5;

alias TextureMap = AssetMap {Texture};
alias ImageMap   = AssetMap {Image};
alias SoundMap   = AssetMap {Sound};
alias MusicMap   = AssetMap {Music};
alias FontMap    = AssetMap {Font};

struct AssetManager {
        TextureMap textures;
        ImageMap images;
        SoundMap sounds;
        MusicMap musics;
        FontMap fonts;
}

enum AssetType {
        TEXTURE,
        IMAGE,
        SOUND,
        MUSIC,
        FONT,
}

macro getFullAssetPath(AssetType $type, name) {
        var $path = "./assets/";
        $switch($type):
                $case AssetType.TEXTURE:
                        $error("don't call this function for a texture");
                $case AssetType.IMAGE:
                        $path = $path +++ "images/";
                $case AssetType.SOUND:
                        $path = $path +++ "sounds/";
                $case AssetType.MUSIC:
                        $path = $path +++ "musics/";
                $case AssetType.FONT:
                        $path = $path +++ "fonts/";
        $endswitch
        return $path.concat(mem, name);
}

macro AssetManager.init(&self) => self.fonts["default"] = map::entry{Font}(rl::getFontDefault());

macro AssetManager.get(&self, AssetType $type, name) {
        String path = getFullAssetPath($type, name);
        defer mem::free(path);
        $switch($type):
                $case AssetType.TEXTURE:
                        if(try self.textures[name]) {
                                self.textures.ref(name);
                                return self.textures[name]!!.data;
                        }
                        Image i = rl::loadTextureFromImage(self.get(AssetType.IMAGE, path));
                        if(!rl::isTextureValid(i)) engine::_log.error("unable to fetch texture: '%s'", path);
                        self.textures[name] = map::entry{Texture}(i);
                        return self.textures[name]!!.data;
                $case AssetType.IMAGE:
                        if(try self.images[name]) {
                                self.images.ref(name);
                                return self.images[name]!!.data;
                        }
                        Image i = rl::loadImage((ZString)path);
                        if(!rl::isImageValid(i)) engine::_log.error("unable to fetch image: '%s'", path);
                        self.images[name] = map::entry{Image}(i);
                        return self.images[name]!!.data;
                $case AssetType.SOUND:
                        if(try self.sounds[name]) {
                                self.sounds.ref(name);
                                return self.sounds[name]!!.data;
                        }
                        Sound s = rl::loadSound((ZString)path);
                        if(!rl::isSoundValid(m)) engine::_log.error("unable to fetch sound: '%s'", path);
                        self.sounds[name] = map::entry{Sound}(m);
                        return self.sounds[name]!!.data;
                $case AssetType.MUSIC:
                        if(try self.musics[name]) {
                                self.musics.ref(name);
                                return self.musics[name]!!.data;
                        }
                        Music m = rl::loadMusicStream((ZString)path);
                        if(!rl::isMusicValid(m)) engine::_log.error("unable to fetch music: '%s'", path);
                        self.musics[name] = map::entry{Music}(m);
                        return self.musics[name]!!.data;
                $case AssetType.FONT:
                        if(try self.fonts[name]) {
                                self.fonts.ref(name);
                                return self.fonts[name]!!.data;
                        }
                        Font f = rl::loadFont((ZString)path);
                        if(!rl::isFontValid(f)) engine::_log.error("unable to fetch font: '%s'", path);
                        self.fonts[name] = map::entry{Font}(f);
                        return self.fonts[name]!!.data;
        $endswitch
}

macro AssetManager.unload(&self, AssetType $type, name) {
        $switch($type):
                $case AssetType.TEXTURE:
                        if(catch self.textures[name]) return;
                        self.textures.unref(name);
                        if(self.textures.getRef(name) == 0) {
                                self.unload(AssetType.IMAGE, name);
                                rl::unloadTexture(self.textures[name]!!.data);
                        }
                $case AssetType.IMAGE:
                        if(catch self.images[name]) return;
                        self.images.unref(name);
                        if(self.images.getRef(name) == 0) rl::unloadImage(self.images[name]!!.data);
                $case AssetType.SOUND:
                        if(catch self.sounds[name]) return;
                        self.sounds.unref(name);
                        if(self.sounds.getRef(name) == 0) rl::unloadSound(self.sounds[name]!!.data);
                $case AssetType.MUSIC:
                        if(catch self.musics[name]) return;
                        self.musics.unref(name);
                        if(self.musics.getRef(name) == 0) rl::unloadMusicStream(self.musics[name]!!.data);
                $case AssetType.FONT:
                        if(catch self.fonts[name]) return;
                        self.fonts.unref(name);
                        if(self.fonts.getRef(name) == 0) rl::unloadFont(self.fonts[name]!!.data);
        $endswitch
}

macro AssetManager.getTexture(&self, name) => self.get(AssetType.TEXTURE, name);
macro AssetManager.getImage(&self, name)   => self.get(AssetType.IMAGE, name);
macro AssetManager.getSound(&self, name)   => self.get(AssetType.SOUND, name);
macro AssetManager.getMusic(&self, name)   => self.get(AssetType.MUSIC, name);
macro AssetManager.getFont(&self, name)    => self.get(AssetType.FONT, name);

macro AssetManager.unloadTexture(&self, name) => self.unload(AssetType.TEXTURE, name);
macro AssetManager.unloadImage(&self, name)   => self.unload(AssetType.IMAGE, name);
macro AssetManager.unloadSound(&self, name)   => self.unload(AssetType.SOUND, name);
macro AssetManager.unloadMusic(&self, name)   => self.unload(AssetType.MUSIC, name);
macro AssetManager.unloadFont(&self, name)    => self.unload(AssetType.FONT, name);
