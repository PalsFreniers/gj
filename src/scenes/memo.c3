module scenes::memo;
import std::core::dstring;
import raylib5;
import scenes;
import engine;
import std::io;

DString memo;

fn void memoUpdate(Label* self) {
        memo.delete(memo.len() - 1);
        if(rl::isKeyPressed(rl::KEY_BACKSPACE) && memo.len() > 0) memo.delete(memo.len() - 1);
        if(rl::isKeyPressed(rl::KEY_DELETE)) memo.clear();
        if(rl::isKeyPressed(rl::KEY_ENTER)) memo.append_char('\n');
        int c = rl::getCharPressed();
        if(c != 0 && ((char)c).is_print()) memo.append_char((char)c);
        memo.append_char('\0');
        self.setText(memo.str_view());
}

fn void checkOutApp() {
        if(rl::isKeyPressed(rl::KEY_ESCAPE)) {
                engine::onUpdate(null);
                engine::gotoScene(scene::DESKTOP);
        }
        if(rl::isKeyDown(rl::KEY_LEFT_CONTROL) || rl::isKeyDown(rl::KEY_RIGHT_CONTROL)) {
                if(rl::isKeyPressed(rl::KEY_S)) {
                        File f = file::open("memo.sav", "w")!!;
                        defer f.close()!!;
                        io::fprintf(&f, "%s\n", memo.str_view())!!;
                        engine::_log.info("written file memo to memo.sav");
                } else if(rl::isKeyPressed(rl::KEY_C)) {
                        rl::setClipboardText((ZString)memo.str_view());                        
                        engine::_log.info("copied memo text to clipboard");
                } else if(rl::isKeyPressed(rl::KEY_V)) {
                        memo.clear();
                        memo.append(rl::getClipboardText().str_view());
                        memo.append_char('\0');
                        engine::_log.info("pasted memo text from clipboard");
                }
        }
}

fn Scene setup() {
        memo = dstring::new(mem);
        memo.append_char('\0');
        Scene s = scene::new("memo");
        float headerSpan = os::header(&s);
        Label* text = label::new("", {10, headerSpan + 10}, color: rl::WHITE);
        text.setUpdateCB(&memoUpdate);
        s["text"] = text;
        s.setInitCallback(fn void(Scene* self) => engine::onUpdate(&checkOutApp));
        return s;
}

