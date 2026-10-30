float bruit(float x){return 0.5+0.25*sin(x*13.1)+0.15*sin(x*27.7+1.3)+0.10*sin(x*53.3+2.1);}
vec3 rendu(vec2 f){
  vec2 uv=(f-0.5*R)/R.y;
  vec3 col=mix(vec3(0.03,0.035,0.06),vec3(0.012,0.014,0.022),smoothstep(-0.4,0.5,uv.y));
  vec3 sarc=vec3(0.20,0.80,0.66),bleu=vec3(0.30,0.62,1.0),violet=vec3(0.52,0.36,1.0);
  for(int k=0;k<3;k++){float i=float(k);
    float x=uv.x+i*0.4;
    float base=-0.02+0.10*sin(x*1.7+i*2.0)+0.04*sin(x*4.3+i)-i*0.04;
    float h=uv.y-base;
    float rideau=smoothstep(-0.07,0.01,h)*exp(-max(h,0.0)*(3.2+i))*bruit(x*1.2+i*3.0);
    vec3 t=mix(sarc,mix(bleu,violet,smoothstep(0.1,0.35,h)),smoothstep(0.02,0.15,h));
    col+=t*rideau*(0.42-0.1*i)*smoothstep(-0.9,0.1,uv.x+0.2*i);}
  vec2 g=floor(f/5.0); float hs=fract(sin(dot(g,vec2(127.1,311.7)))*43758.5);
  col+=vec3(0.75,0.82,1.0)*step(0.9992,hs)*0.4*smoothstep(-0.1,0.4,uv.y);
  float sol=-0.40+0.04*sin(uv.x*2.3)+0.02*sin(uv.x*5.1+1.0);
  if(uv.y<sol) col=vec3(0.012,0.013,0.018)+vec3(0.1,0.2,0.25)*0.03*exp((uv.y-sol)*25.0);
  col*=1.0-0.25*dot(uv,uv); return pow(col,vec3(0.92));}
