module scenes::quit;
import scenes::scene;
import raylib5;
import engine;
import main;

const float FADE_LEN = 1.5;
const float WAIT_LEN = 0.7;
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
                                state = STATE_STOP;
                        }
                case STATE_STOP:
                        engine::quit();
                        return;
                default:
                        unreachable("logo anim");
       }
}

fn Scene setup() {
        Scene s = scene::new("end");
        Label* logo = label::new("JUMPER OS", {0, 0}, size: 100, color: rl::BLACK);
        logo.setPos((float[<2>])main::SCREEN_SIZE / 2 - logo.getSize() / 2);
        logo.setUpdateCB(&logoUpdate);
        s["logo"] = logo;
        return s;
}
