module engine::math;

fn float lerp(float a, float b, float t) => a + (b - a) * t;
