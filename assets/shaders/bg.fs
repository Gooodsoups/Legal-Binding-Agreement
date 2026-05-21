#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP number time;

#define PIXEL_SIZE_FAC 700.
#define BLACK 0.6*vec4(79./255.,99./255., 103./255., 1./0.6)

mat2 rotate(float angle){
    return mat2(cos(angle),-sin(angle),
                sin(angle),cos(angle));
}

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    //Convert to UV coords (0-1) and floor for pixel effect
    MY_HIGHP_OR_MEDIUMP number pixel_size = length(love_ScreenSize.xy)/PIXEL_SIZE_FAC;
    MY_HIGHP_OR_MEDIUMP vec2 uv = (floor(screen_coords.xy*(1./pixel_size))*pixel_size - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    MY_HIGHP_OR_MEDIUMP number uv_len = length(uv);

    float conf_time = u_time / 5.;
    vec2 st = uv * rotate(90.);
    vec2 uv2 = uv * rotate(180.);

    vec4 tex = texture(u_textures[0], st + vec2(sin((conf_time) + st.y * 3.) / 3., 0));

    vec4 fade = vec4(vec3(sin(uv.y * 3.1)),0.5);

    out_color = tex * vec4(0.408, 0.235, 0.071, 100.000) * 1.3 * fade;

    return ret_col*(1. - mod_flash) + mod_flash*vec4(1., 1., 1., 1.);
}