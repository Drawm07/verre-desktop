// Éclipse : bord d'une planète éclairé par derrière, halo bleu -> violet
vec3 rendu(vec2 f){
  vec2 uv=(f-0.5*R)/R.y;               // y vers le haut
  vec3 fond=mix(vec3(0.035,0.038,0.05),vec3(0.06,0.065,0.085),smoothstep(-0.6,0.6,uv.y));
  vec2 c=vec2(0.55,-1.55); float r=1.55;  // planète en bas à droite
  float d=length(uv-c)-r;
  float ang=atan(uv.y-c.y,uv.x-c.x);
  float lumi=smoothstep(0.2,1.9,ang);       // plus fort vers le haut-gauche de l'arc
  vec3 bleu=vec3(0.36,0.70,1.0), violet=vec3(0.52,0.38,1.0), sarc=vec3(0.25,0.72,0.70);
  vec3 teinte=mix(sarc,mix(bleu,violet,smoothstep(1.2,2.0,ang)),smoothstep(0.6,1.2,ang));
  float lisere=exp(-abs(d)*260.0)*1.4;      // fin trait lumineux
  float halo=exp(-max(d,0.0)*9.0)*0.55+exp(-max(d,0.0)*38.0)*0.6;
  vec3 col=fond+teinte*(lisere+halo*(d>0.0?1.0:0.0))*lumi;
  if(d<0.0){ // surface de la planète, très sombre avec dégradé atmosphérique intérieur
    float inner=exp(d*14.0);
    col=mix(vec3(0.012,0.013,0.018),teinte*0.22,inner*lumi)+teinte*lisere*lumi;
  }
  // anneau fin incliné
  vec2 q=uv-c; q=mat2(cos(0.18),-sin(0.18),sin(0.18),cos(0.18))*q; q.y*=3.2;
  float an=abs(length(q)-2.15);
  float face=step(0.0,d)+step(q.y,0.0)*(1.0-step(0.0,d)); // devant la planète seulement en bas
  col+=mix(bleu,violet,0.5)*exp(-an*900.0)*0.35*lumi*face;
  // étoiles très rares et discrètes
  vec2 g=floor(f/6.0); float h=fract(sin(dot(g,vec2(127.1,311.7)))*43758.5);
  col+=vec3(0.7,0.8,1.0)*step(0.9993,h)*0.35*step(0.0,d)*smoothstep(0.1,0.6,uv.y+0.4);
  float v=1.0-0.35*dot(uv*0.6,uv*0.6); col*=v;
  return pow(col,vec3(0.95));
}
