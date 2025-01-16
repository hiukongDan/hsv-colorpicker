#ifdef VERTEX
#pragma language glsl3

vec4 position(mat4 transform_projection, vec4 vertex_position)
{
    // The order of operations matters when doing matrix multiplication.
    return transform_projection * vertex_position;
}

#endif

#ifdef PIXEL
#pragma language glsl3

uniform vec3 ColorHSV;

vec3 hsv2rgb(float h,float s,float v) {
    return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    float h = ColorHSV.x;
    float s = mix(0, ColorHSV.y, texture_coords.x);
    float v = mix(0, ColorHSV.z, texture_coords.y);
    color = vec4(hsv2rgb(h,s,v), color.a);
    return color;
}

#endif