import sys, os, base64, time
from playwright.sync_api import sync_playwright
W,H=3840,2160
HTML='''<!doctype html><html><body style="margin:0;background:#000"><canvas id="c" width="%d" height="%d"></canvas>
<script>
const c=document.getElementById('c');const gl=c.getContext('webgl2',{preserveDrawingBuffer:true,antialias:false});
const vs=`#version 300 es
in vec2 p;void main(){gl_Position=vec4(p,0,1);}`;
const fs=`#version 300 es
precision highp float;
uniform vec2 R;out vec4 o;
%s
void main(){vec2 f=gl_FragCoord.xy;vec3 col=rendu(f);
float d=fract(sin(dot(f,vec2(12.9898,78.233)))*43758.5453)-0.5;col+=d/255.0;
o=vec4(col,1);}`;
function sh(t,s){const x=gl.createShader(t);gl.shaderSource(x,s);gl.compileShader(x);if(!gl.getShaderParameter(x,gl.COMPILE_STATUS))throw gl.getShaderInfoLog(x);return x;}
const pr=gl.createProgram();gl.attachShader(pr,sh(gl.VERTEX_SHADER,vs));gl.attachShader(pr,sh(gl.FRAGMENT_SHADER,fs));gl.linkProgram(pr);gl.useProgram(pr);
const b=gl.createBuffer();gl.bindBuffer(gl.ARRAY_BUFFER,b);gl.bufferData(gl.ARRAY_BUFFER,new Float32Array([-1,-1,1,-1,-1,1,1,1]),gl.STATIC_DRAW);
const l=gl.getAttribLocation(pr,'p');gl.enableVertexAttribArray(l);gl.vertexAttribPointer(l,2,gl.FLOAT,false,0,0);
gl.uniform2f(gl.getUniformLocation(pr,'R'),c.width,c.height);
gl.enable(gl.SCISSOR_TEST);
window.tuile=(x,y,w,h)=>{gl.scissor(x,y,w,h);gl.drawArrays(gl.TRIANGLE_STRIP,0,4);gl.finish();return 1;};
window.pret=1;
</script></body></html>'''
def rendre(src, out, tw=480, th=270):
    code=open(src).read()
    with sync_playwright() as p:
        b=p.chromium.launch(args=['--use-gl=angle','--use-angle=swiftshader','--enable-unsafe-swiftshader','--ignore-gpu-blocklist'])
        pg=b.new_page(viewport={'width':W,'height':H})
        msgs=[];pg.on('console',lambda m:msgs.append(m.text));pg.on('pageerror',lambda e:msgs.append(str(e)))
        pg.set_content(HTML%(W,H,code.replace('`','')))
        if not pg.evaluate('window.pret===1'): print(msgs); raise SystemExit('erreur shader')
        t=time.time()
        for y in range(0,H,th):
            for x in range(0,W,tw): pg.evaluate(f'tuile({x},{y},{tw},{th})')
        data=pg.evaluate("document.getElementById('c').toDataURL('image/png')")
        open(out,'wb').write(base64.b64decode(data.split(',')[1]))
        print(out, round(time.time()-t,1),'s')
        b.close()
if __name__=='__main__': rendre(sys.argv[1], sys.argv[2])
