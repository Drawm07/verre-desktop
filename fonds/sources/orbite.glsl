mat3 rot(float a,float b){float ca=cos(a),sa=sin(a),cb=cos(b),sb=sin(b);
  return mat3(1,0,0, 0,ca,sa, 0,-sa,ca)*mat3(cb,0,-sb, 0,1,0, sb,0,cb);}
float ruban(vec3 p,float Rr,float h,float e){vec2 q=vec2(length(p.xz)-Rr,p.y);
  vec2 d=abs(q)-vec2(e,h)+0.015;return length(max(d,0.0))+min(max(d.x,d.y),0.0)-0.015;}
const int N=3;
vec4 scene(vec3 p){ // distance, id
  float d=length(p)-0.95; float id=0.0;
  float Rs[6]=float[](1.40,2.00,2.70,0.,0.,0.);
  float Hs[6]=float[](0.12,0.24,0.32,0.,0.,0.);
  float A[6]=float[](1.20,0.95,1.10,0.,0.,0.);
  float B[6]=float[](0.35,-0.25,0.10,0.,0.,0.);
  for(int i=0;i<N;i++){float r=ruban(rot(A[i],B[i])*p,Rs[i],Hs[i],0.028);
    if(r<d){d=r;id=float(i+1);}}
  return vec4(d,id,0,0);}
vec3 nrm(vec3 p){vec2 e=vec2(0.0008,0);return normalize(vec3(scene(p+e.xyy).x-scene(p-e.xyy).x,scene(p+e.yxy).x-scene(p-e.yxy).x,scene(p+e.yyx).x-scene(p-e.yyx).x));}
vec3 fondc(vec2 uv){return mix(vec3(0.028,0.03,0.04),vec3(0.07,0.075,0.095),smoothstep(-0.2,0.9,uv.x*0.5+uv.y*0.4+0.3));}
vec3 tir(vec2 uv){
  vec3 ro=vec3(0.0,0.35,7.0); vec3 rd=normalize(vec3(uv-vec2(0.40,0.02),-2.05)); rd.y-=0.05;
  float t=0.0; vec4 h; bool touche=false;
  for(int i=0;i<140;i++){h=scene(ro+rd*t); if(h.x<0.0004){touche=true;break;} t+=h.x*0.9; if(t>14.0)break;}
  if(!touche) return fondc(uv);
  vec3 p=ro+rd*t, n=nrm(p), v=-rd;
  vec3 L=normalize(vec3(-0.65,0.75,0.45));
  float ao=0.0,s=1.0; for(int k=1;k<=5;k++){float dd=0.06*float(k);ao+=s*(dd-scene(p+n*dd).x);s*=0.6;} ao=clamp(1.0-2.2*ao,0.0,1.0);
  float sh=1.0; float tt=0.02; for(int k=0;k<32;k++){float hh=scene(p+L*tt).x; sh=min(sh,12.0*hh/tt); tt+=clamp(hh,0.02,0.25); if(hh<0.0005||tt>6.0)break;} sh=clamp(sh,0.0,1.0); if(h.y<0.5) sh=mix(sh,1.0,0.75);
  vec3 bleu=vec3(0.36,0.70,1.0), violet=vec3(0.50,0.38,1.0), sarc=vec3(0.22,0.70,0.68);
  float fres=pow(1.0-max(dot(n,v),0.0),3.0);
  float k=fract(dot(n,vec3(0.35,0.55,0.25))*0.9+h.y*0.17+fres*0.6);
  vec3 iri=k<0.5?mix(sarc,bleu,k*2.0):mix(bleu,violet,(k-0.5)*2.0);
  vec3 base=h.y<0.5?vec3(0.13,0.13,0.22):mix(vec3(0.035,0.045,0.07),vec3(0.05,0.045,0.08),fract(h.y*0.37));
  float dif=max(dot(n,L),0.0)*sh;
  vec3 hv=normalize(L+v); float spe=pow(max(dot(n,hv),0.0),h.y<0.5?35.0:90.0)*sh*(h.y<0.5?0.35:1.0);
  float rim=pow(1.0-max(dot(n,v),0.0),5.0);
  vec3 col=base*(0.25+1.2*dif)*ao + iri*(0.55*fres*ao + 0.9*rim) + vec3(0.85,0.9,1.0)*spe*0.9;
  if(h.y<0.5) col+=mix(bleu,violet,0.6)*0.22*pow(dif,1.5)*ao;
  col+=iri*0.10*max(dot(n,normalize(vec3(0.8,-0.2,-0.6))),0.0)*ao; // contre-jour
  return col;}
vec3 rendu(vec2 f){vec3 c=vec3(0);
  for(int j=0;j<2;j++)for(int i=0;i<2;i++){vec2 o=vec2(float(i),float(j))*0.5-0.25; c+=tir((f+o-0.5*R)/R.y);}
  c*=0.25; vec2 uv=(f-0.5*R)/R.y; c*=1.0-0.3*dot(uv*0.7,uv*0.7);
  return pow(c,vec3(0.92));}
