import os
W,H=3840,2160
def mix(a,b,t):
    a=[int(a[i:i+2],16) for i in (1,3,5)]; b=[int(b[i:i+2],16) for i in (1,3,5)]
    return '#%02x%02x%02x'%tuple(round(a[k]+(b[k]-a[k])*t) for k in range(3))
def light(c,t): return mix(c,'#ffffff',t)
uid=[0]
def capsules(x,y,angle,height,n,step,c0,c1,length=9000,flip=False):
    """Bandes en capsule imbriquées. (x,y) = bout arrondi de la plus grande. L'autre bout part hors écran."""
    out=[f'<g transform="translate({x},{y}) rotate({angle})">']
    for i in range(n):
        t=i/max(1,n-1); h=height-2*i*step; x0=i*step
        if h<=0: break
        c=mix(c0,c1,t); uid[0]+=1; g=f'g{uid[0]}'
        out.append(f'<linearGradient id="{g}" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="{light(c,0.06)}"/><stop offset="1" stop-color="{mix(c,"#000000",0.18)}"/></linearGradient>')
        out.append(f'<rect x="{x0}" y="{-h/2}" width="{length}" height="{h}" rx="{h/2}" fill="url(#{g})" filter="url(#ombre)" stroke="{light(c,0.10)}" stroke-opacity="0.35" stroke-width="2"/>')
    out.append('</g>'); return '\n'.join(out)
def anneaux(cx,cy,r,n,step,c0,c1):
    out=[]
    for i in range(n):
        t=i/max(1,n-1); rr=r-i*step
        if rr<=0: break
        c=mix(c0,c1,t); uid[0]+=1; g=f'g{uid[0]}'
        out.append(f'<radialGradient id="{g}" cx="0.35" cy="0.3" r="0.9"><stop offset="0" stop-color="{light(c,0.07)}"/><stop offset="1" stop-color="{mix(c,"#000000",0.2)}"/></radialGradient>')
        out.append(f'<circle cx="{cx}" cy="{cy}" r="{rr}" fill="url(#{g})" filter="url(#ombre)" stroke="{light(c,0.1)}" stroke-opacity="0.3" stroke-width="2"/>')
    return '\n'.join(out)
def svg(bg0,bg1,body,vign=0.55):
    return f'''<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}">
<defs>
<filter id="ombre" x="-20%" y="-20%" width="140%" height="140%"><feDropShadow dx="-10" dy="22" stdDeviation="26" flood-color="#000" flood-opacity="0.55"/></filter>
<linearGradient id="fond" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="{bg0}"/><stop offset="1" stop-color="{bg1}"/></linearGradient>
<radialGradient id="vign" cx="0.5" cy="0.45" r="0.75"><stop offset="0.55" stop-color="#000" stop-opacity="0"/><stop offset="1" stop-color="#000" stop-opacity="{vign}"/></radialGradient>
</defs>
<rect width="{W}" height="{H}" fill="url(#fond)"/>
{body}
<rect width="{W}" height="{H}" fill="url(#vign)"/>
</svg>'''
themes={}
# 1. Graphite : esprit de la référence
themes['01-graphite']=svg('#1c1d22','#121318',
  capsules(300,1500,-45,1150,10,52,'#1e2026','#4b4d58')+
  capsules(1750,1950,-45,1500,6,62,'#262830','#4e505c'))
# 2. Nuit bleue : anneaux depuis le coin + capsule
themes['02-nuit-bleue']=svg('#0e1526','#080c17',
  anneaux(3700,2250,1650,9,150,'#13203a','#3e7ec4')+
  capsules(-150,900,-28,600,6,44,'#122038','#2a5689'))
# 3. Améthyste
themes['03-amethyste']=svg('#18122a','#0e0a19',
  capsules(600,1750,-35,1300,8,70,'#20183a','#6a55a8')+
  capsules(2350,1250,-35,620,6,48,'#1d1634','#4b3d7e'))
# 4. Lagon
themes['04-lagon']=svg('#0d1d20','#081214',
  capsules(1000,1050,90,800,7,52,'#11292c','#2f8187')+
  capsules(1950,650,90,1000,8,58,'#0f2427','#3a9aa0')+
  capsules(2950,1250,90,800,7,52,'#10272a','#286b70'))
# 5. Aurore : palette de l'interface actuelle (bleu, violet, sarcelle)
themes['05-aurore']=svg('#17181c','#101115',
  capsules(150,1400,-40,1000,7,58,'#1a2b44','#3f78b8')+
  capsules(1500,2000,-40,1200,7,64,'#251d40','#5e4c9c')+
  capsules(2900,2200,-40,900,6,60,'#14302f','#2f8a8a'))
for k,v in themes.items():
    open(k+'.html','w').write('<!doctype html><html><head><style>html,body{margin:0;background:#000}svg{display:block}</style></head><body>'+v+'</body></html>')
from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    b=p.chromium.launch(); pg=b.new_page(viewport={'width':W,'height':H})
    for k in themes:
        pg.goto('file://'+os.path.abspath(k+'.html')); pg.wait_for_timeout(600)
        pg.screenshot(path=f'/mnt/user-data/outputs/Themes/{k}.png')
    b.close()
print('ok')
