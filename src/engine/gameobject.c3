module engine::gameobject::object;
import engine::message;

interface IGameObject {
        fn void init();
        fn void fini();
        fn void recv(Message msg);
        fn void setPos(float[<2>] pos);
        fn float[<2>] getPos();
        fn float[<2>] getSize();
        fn bool collidable();
        fn void collide(IGameObject);
        fn int getZ();
        fn void update();
        fn void draw();
}

fn bool IGameObject.isCollide(self, IGameObject other) {
        if(!self.collidable() || !other.collidable()) return false;
        float[<4>] selfRect = {self.getPos(), self.getSize()};
        float[<4>] otherRect = {other.getPos(), other.getSize()};
        if(selfRect.x > otherRect.x + otherRect.z) return false;
        if(selfRect.y > otherRect.y + otherRect.w) return false;
        if(otherRect.x > selfRect.x + selfRect.z) return false;
        if(otherRect.y > selfRect.y + selfRect.w) return false;
        return true;
}
