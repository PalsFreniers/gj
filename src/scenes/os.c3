module scenes::os;
import raylib5;
import engine;
import main;
import std;

float[<2>] headerSize;

DString date;

fn void dateUpdate(Label* self) {
        date.free();
        date = dstring::new(mem);
        int secs = (int)(((long)time::now().to_seconds()) % (3600 * 24));
        int hour = (secs / 3600 + 2) % 24;
        int min = (secs / 60) % 60;
        secs = secs % 60;
        io::fprintf(&date, "%02d:%02d:%02d\0", hour, min, secs)!!;
        self.setText(date.str_view());
        self.setPos({(float)main::SCREEN_SIZE.x / 2 - self.getSize().x / 2, 5});
}

fn float header(Scene* s) {
        Label* logo = label::new("JUMPER OS", {5, 5}, color: rl::WHITE);
        logo.setZ(1);
        (*s)["logo"] = logo;
        Label* date = label::new("", {0, 0}, color: rl::WHITE);
        date.setZ(1);
        date.setUpdateCB(&dateUpdate);
        (*s)["date"] = date;
        Rect* bar = rect::new({0, 0}, {main::SCREEN_SIZE.x, logo.getSize().y + 10}, (Color){0x1e, 0x1e, 0x1e, 255});
        (*s)["bar"] = bar;
        headerSize = {main::SCREEN_SIZE.x, logo.getSize().y + 10};
        return logo.getSize().y + 10;
}
