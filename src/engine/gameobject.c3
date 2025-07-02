module engine::gameobject::object;
import engine::message;

interface IGameObject {
        fn void init();
        fn void fini();
        fn void recv(Message msg);
        fn void setPos(float[<2>] pos);
        fn float[<2>] getPos();
        fn void update();
        fn void draw();
}
