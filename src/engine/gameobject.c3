module engine::gameobject::go;

interface IGameObject {
        fn void init();
        fn void fini();
        fn void recv(Message msg);
        fn void accel(float[<2>] dir);
        fn void setPos(float[<2>] pos);
        fn float[<2>] getPos();
        fn void update();
        fn void draw();
}
