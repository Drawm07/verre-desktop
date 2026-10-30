float seg(vec2 p,vec2 a,vec2 b){vec2 pa=p-a,ba=b-a;float h=clamp(dot(pa,ba)/dot(ba,ba),0.0,1.0);return length(pa-ba*h);}
vec3 groupe(vec2 uv,vec2 a,vec2 b,float r0,float pas,int n,vec3 col,inout float dejaFond){
  vec3 bleu=vec3(0.36,0.70,1.0),violet=vec3(0.50,0.38,1.0),sarc=vec3(0.22,0.72,0.70);
  vec3 add=vec3(0);
  for(int k=0;k<8;k++){ if(k>=n)break; float r=r0-float(k)*pas; float d=seg(uv,a,b)-r;
    vec2 ab=normalize(b-a); float t=dot(uv-a,ab);
    vec3 teinte=mix(mix(violet,bleu,smoothstep(0.0,0.8,t)),sarc,smoothstep(0.8,1.8,t));
    float fade=float(k)/float(n);
    if(d<0.0){ col=mix(vec3(0.030,0.032,0.045),vec3(0.06,0.065,0.09),fade); dejaFond=1.0;}
    add+=teinte*exp(-abs(d)*1100.0)*(0.75-0.45*fade);
    add+=teinte*exp(-max(d,0.0)*40.0)*0.035*(1.0-fade)*step(0.0,d);
  }
  return col+add;}
vec3 rendu(vec2 f){
  vec3 c=vec3(0);
  for(int j=0;j<2;j++)for(int i=0;i<2;i++){vec2 uv=(f+vec2(float(i),float(j))*0.5-0.25-0.5*R)/R.y;
    vec3 col=mix(vec3(0.022,0.024,0.032),vec3(0.05,0.053,0.068),smoothstep(-0.6,0.9,uv.x*0.6+uv.y*0.5));
    float fd=0.0;
    col=groupe(uv,vec2(0.05,-0.18),vec2(2.4,1.9),0.30,0.045,6,col,fd);
    col=groupe(uv,vec2(0.55,-0.62),vec2(3.0,1.5),0.20,0.040,5,col,fd);
    c+=col;}
  c*=0.25; vec2 uv=(f-0.5*R)/R.y; c*=1.0-0.28*dot(uv,uv); return pow(c,vec3(0.92));}
