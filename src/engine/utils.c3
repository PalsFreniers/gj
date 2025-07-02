module engine::utils;
import raylib5;

macro float[<2>].vec2(self) => (Vector2) {self.x, self.y};
macro char[<4>].color(self) => (Color) {self.r, self.g, self.b, self.a};
