in vec4 texcovar;
out vec4 fragColor;

#if defined(ANAGLYPH) || defined(STIPPLE)
uniform sampler2D lefteyetex;
uniform sampler2D righteyetex;
#else
uniform sampler2D colortex;
#  ifdef DEPTH
uniform sampler2D depthtex;
#  endif
#endif

#ifdef STIPPLE
#  define STIPPLE_COLUMN 0
#  define STIPPLE_ROW 1

uniform int stippleid;
#endif

void main()
{
  vec2 co = texcovar.xy;
#ifdef STIPPLE
  if (stippleid == STIPPLE_ROW) {
    int result = int(mod(gl_FragCoord.y, 2));
    if (result != 0) {
      fragColor = texture2D(lefteyetex, co);
    }
    else {
      fragColor = texture2D(righteyetex, co);
    }
  }
  else if (stippleid == STIPPLE_COLUMN) {
    int result = int(mod(gl_FragCoord.x, 2));
    if (result == 0) {
      fragColor = texture2D(lefteyetex, co);
    }
    else {
      fragColor = texture2D(righteyetex, co);
    }
  }
#elif defined(ANAGLYPH)
  fragColor = vec4(texture2D(lefteyetex, co).r, texture2D(righteyetex, co).gb, 1.0);
#else
  fragColor = texture2D(colortex, co);
#  ifdef DEPTH
  gl_FragDepth = texture2D(depthtex, co).x;
#  endif
#endif
}
