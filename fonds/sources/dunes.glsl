float crete(float x,float i){return 0.12*sin(x*1.3+i*1.7)+0.06*sin(x*2.9+i*2.3+1.0)+0.025*sin(x*6.1+i);}
vec3 rendu(vec2 f){
  vec2 uv=(f-0.5*R)/R.y;
  vec3 ciel=mix(vec3(0.055,0.05,0.09),vec3(0.02,0.022,0.035),smoothstep(-0.1,0.5,uv.y));
  vec2 lune=vec2(0.48,0.20); float dl=length(uv-lune);
  ciel+=vec3(0.45,0.55,0.95)*exp(-dl*5.0)*0.12+vec3(0.6,0.7,1.0)*smoothstep(0.052,0.048,dl)*0.55;
  vec3 col=ciel;
  for(int k=0;k<6;k++){float i=float(k); float y0=0.02-i*0.075;
    float y=y0+crete(uv.x+i*0.37,i)*(1.0-i*0.08);
    float dy=uv.y-y;
    if(dy<0.0){
      float prof=i/5.0;
      vec3 c=mix(vec3(0.19,0.18,0.30),vec3(0.018,0.02,0.03),pow(prof,0.8));
      c=mix(c,c*0.55,smoothstep(0.0,0.25,-dy)); // ombre sous la crête
      float pente=crete(uv.x+0.002+i*0.37,i)-crete(uv.x+i*0.37,i);
      float lumi=smoothstep(-0.0004,0.0006,-pente); // versant tourné vers la lune
      c+=mix(vec3(0.30,0.45,0.85),vec3(0.42,0.32,0.80),prof)*0.10*lumi*(1.0-prof*0.7)*exp(dy*30.0);
      c+=vec3(0.45,0.6,1.0)*exp(-abs(dy)*1400.0)*0.35*(1.0-prof*0.8); // liseré de crête
      col=c;}
  }
  col*=1.0-0.25*dot(uv,uv);
  return pow(col,vec3(0.92));}
