float haut(vec2 p){
  vec2 u=mat2(0.86,-0.5,0.5,0.86)*p;
  float w=0.55*sin(u.y*1.3+0.6);
  return 0.50*sin(u.x*2.6+w*2.2)
        +0.22*sin(u.x*4.9+u.y*0.9+1.3+w)
        +0.10*sin(u.x*8.3-u.y*1.4+2.0);
}
vec3 tir(vec2 uv){
  vec2 p=uv*1.6; float e=0.0015;
  float h=haut(p);
  float hx=(haut(p+vec2(e,0))-h)/e, hy=(haut(p+vec2(0,e))-h)/e;
  vec3 n=normalize(vec3(-hx*0.32,-hy*0.32,1.0));
  vec3 V=vec3(0,0,1), L=normalize(vec3(0.55,0.65,0.55));
  float dif=max(dot(n,L),0.0);
  float spe=pow(max(dot(reflect(-L,n),V),0.0),18.0);
  float spe2=pow(max(dot(reflect(-L,n),V),0.0),120.0);
  vec3 bleu=vec3(0.36,0.70,1.0), violet=vec3(0.50,0.38,1.0);
  float k=smoothstep(-0.8,0.9,uv.x+uv.y*0.4);
  vec3 teinte=mix(violet,bleu,k);
  vec3 base=vec3(0.035,0.04,0.065);
  vec3 col=base*(0.4+dif*1.4)+teinte*spe*0.35+vec3(0.8,0.88,1.0)*spe2*0.25;
  col*=0.55+0.45*smoothstep(-1.0,0.5,h); // creux plus sombres
  float masque=smoothstep(-0.95,0.35,uv.x);
  vec3 fond=vec3(0.03,0.032,0.045);
  return mix(fond,col,masque);
}
vec3 rendu(vec2 f){vec3 c=vec3(0);
  for(int j=0;j<2;j++)for(int i=0;i<2;i++){vec2 o=vec2(float(i),float(j))*0.5-0.25;c+=tir((f+o-0.5*R)/R.y);}
  c*=0.25; vec2 uv=(f-0.5*R)/R.y; c*=1.0-0.25*dot(uv,uv); return pow(c,vec3(0.92));}
