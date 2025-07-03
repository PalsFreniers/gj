import engine;
import raylib5;
import std;
import appicon;

const int[<2>] SCREEN_SIZE = {900, 600};
const float[<2>] GRAVITY = {0, 100};

const int SCENE_LOGO = 0;
const int SCENE_DESKTOP = 1;

const MSG_LOGO_END = msg::@new();

fn void transitionEnd(Message m) {
        if(m == MSG_LOGO_END) {
                engine::gotoScene(1);
                engine::onMessage(null);
        }
}

const float FADE_LEN = 2;
const float WAIT_LEN = 1.5;
float animationDuration;
const STATE_FADE_IN  = 0;
const STATE_WAIT     = 1;
const STATE_FADE_OUT = 2;
const STATE_STOP     = 3;
int state;

fn void logoUpdate(Label* self) {
       animationDuration += engine::deltaTime(); 
       switch(state) {
                case STATE_FADE_IN:
                        float c = math::lerp(0, 1, animationDuration / FADE_LEN);
                        char[<4>] col = {(char)(c * 255), (char)(c * 255), (char)(c * 255), 255};
                        self.color = col.color();
                        if(animationDuration >= FADE_LEN) {
                                state = STATE_WAIT;
                                animationDuration -= FADE_LEN;
                        }
                case STATE_WAIT:
                        self.color = rl::WHITE;
                        if(animationDuration >= WAIT_LEN) {
                                state = STATE_FADE_OUT;
                                animationDuration -= WAIT_LEN;
                        }
                case STATE_FADE_OUT:
                        float c = math::lerp(1, 0, animationDuration / FADE_LEN);
                        char[<4>] col = {(char)(c * 255), (char)(c * 255), (char)(c * 255), 255};
                        self.color = col.color();
                        if(animationDuration >= FADE_LEN) {
                                animationDuration -= FADE_LEN;
                                engine::sendMessage("engine", MSG_LOGO_END);
                        }
                case STATE_STOP:
                        return;
                default:
                        unreachable("logo anim");
       }
}

fn Scene scene1Setup() {
        Scene s = scene::new("start");
        Label* logo = label::new("JUMPER OS", {0, 0}, size: 100, color: rl::BLACK);
        logo.setPos((float[<2>])SCREEN_SIZE / 2 - logo.getSize() / 2);
        logo.setUpdateCB(&logoUpdate);
        s["logo"] = logo;
        engine::onMessage(&transitionEnd);
        return s;
}

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
        self.setPos({(float)SCREEN_SIZE.x / 2 - self.getSize().x / 2, 5});
}

fn Scene scene2Setup() {
        Scene s = scene::new("OS");
        Label* logo = label::new("JUMPER OS", {5, 5}, color: rl::WHITE);
        logo.setZ(1);
        s["logo"] = logo;
        Label* date = label::new("", {0, 0}, color: rl::WHITE);
        date.setZ(1);
        date.setUpdateCB(&dateUpdate);
        s["date"] = date;
        Rect* bar = rect::new({0, 0}, {SCREEN_SIZE.x, logo.getSize().y + 10}, (Color){0x1e, 0x1e, 0x1e, 255});
        s["bar"] = bar;
        AppIcon* noteIcon = appicon::new("Memo", {100, 100}, {50, 50}, "note.png", rl::WHITE);
        s["noteIcon"] = noteIcon;
        return s;
}

fn void main() {
        engine::init();
        engine::addScene(scene1Setup());
        engine::addScene(scene2Setup());
        engine::setTitle("Game");
        engine::setSize(SCREEN_SIZE);
        engine::run();
        engine::cleanup();
}
