# Generates the two M&M runtime sequence diagrams (arc42 section 6) as SVG.
# Redrawn in English from figure 12.7 of the German original, which is one wide
# diagram with seven lifelines. Split in two here because the site sets prose in
# a 68ch column: a seven-lifeline diagram scaled into that column renders its
# labels at about 8px. Two four/five-lifeline diagrams read at ~11px.
import os, sys

OUT = os.path.dirname(os.path.abspath(__file__))
FS, FH = 16, 16          # message / header font size
BOXW, BOXH = 176, 58     # lifeline header box


class Seq:
    def __init__(self, lifelines, height, pitch=196, left=104):
        self.x = {}
        self.o = []
        for i, (key, lines) in enumerate(lifelines):
            self.x[key] = left + i * pitch
        self.w = left + (len(lifelines) - 1) * pitch + BOXW // 2 + 40
        self.h = height
        a = self.o.append
        a(f'<svg xmlns="http://www.w3.org/2000/svg" width="{self.w}" height="{height}" '
          f'viewBox="0 0 {self.w} {height}" font-family="Helvetica, Arial, sans-serif">')
        a('<defs><marker id="ah" markerWidth="10" markerHeight="8" refX="9" refY="4" '
          'orient="auto"><path d="M0,0 L10,4 L0,8 z" fill="#333"/></marker></defs>')
        a(f'<rect width="{self.w}" height="{height}" fill="#fff"/>')
        for key, lines in lifelines:
            x = self.x[key]
            a(f'<rect x="{x-BOXW//2}" y="12" width="{BOXW}" height="{BOXH}" fill="#fff" '
              'stroke="#333" stroke-width="1.6"/>')
            if len(lines) == 1:
                a(f'<text x="{x}" y="48" text-anchor="middle" font-size="{FH}" fill="#111">{lines[0]}</text>')
            else:
                a(f'<text x="{x}" y="38" text-anchor="middle" font-size="{FH}" fill="#111">{lines[0]}</text>')
                a(f'<text x="{x}" y="58" text-anchor="middle" font-size="{FH}" fill="#111">{lines[1]}</text>')
            a(f'<line x1="{x}" y1="{12+BOXH}" x2="{x}" y2="{height-24}" stroke="#333" '
              'stroke-width="1.2" stroke-dasharray="7,6"/>')

    def bar(self, k, y1, y2):
        x = self.x[k]
        self.o.append(f'<rect x="{x-8}" y="{y1}" width="16" height="{y2-y1}" fill="#fff" '
                      'stroke="#333" stroke-width="1.4"/>')

    def msg(self, a_, b_, y, label, lx=None):
        x1, x2 = self.x[a_], self.x[b_]
        x1 += 8 if x2 > x1 else -8
        x2 += -8 if x2 > x1 else 8
        self.o.append(f'<line x1="{x1}" y1="{y}" x2="{x2}" y2="{y}" stroke="#333" '
                      'stroke-width="1.4" marker-end="url(#ah)"/>')
        self.o.append(f'<text x="{lx if lx is not None else (x1+x2)//2}" y="{y-8}" '
                      f'text-anchor="middle" font-size="{FS}" fill="#111">{label}</text>')

    def selfmsg(self, k, y, label, drop=28, out=74):
        x = self.x[k]
        self.o.append(f'<path d="M{x+8},{y} L{x+out},{y} L{x+out},{y+drop} L{x+10},{y+drop}" '
                      'fill="none" stroke="#333" stroke-width="1.4" marker-end="url(#ah)"/>')
        self.o.append(f'<text x="{x+out+10}" y="{y+5}" font-size="{FS}" fill="#111">{label}</text>')

    def destroy(self, k, y):
        x = self.x[k]
        self.o.append(f'<line x1="{x-11}" y1="{y-11}" x2="{x+11}" y2="{y+11}" stroke="#333" stroke-width="2"/>')
        self.o.append(f'<line x1="{x-11}" y1="{y+11}" x2="{x+11}" y2="{y-11}" stroke="#333" stroke-width="2"/>')

    def raw(self, s):
        self.o.append(s)

    def save(self, name):
        self.o.append('</svg>')
        open(os.path.join(OUT, name), "w").write("\n".join(self.o))
        return self.w


# ---- Phase 1: read the tapes, fill the migration database -------------------
a = Seq([("mc",  ["Migration", "Controller"]),
         ("src", ["«external»", "VSAM source data"]),
         ("rdr", ["VSAM", "Reader"]),
         ("db",  ["Migration", "database"])], height=470)
a.bar("mc", 100, 420)
a.bar("rdr", 112, 400)
a.bar("src", 148, 380)
a.bar("db", 176, 410)
a.msg("mc", "rdr", 112, "start()")
y = 152
for rd, wr in [("read persons", "write persons"), ("read accounts", "write accounts"),
               ("read addresses", "write addresses"), ("read bank data", "write bank data")]:
    a.msg("rdr", "src", y, rd)
    a.msg("rdr", "db", y + 30, wr)
    y += 60
a.destroy("rdr", 400)
a.save("06-runtime-1.svg")

# ---- Phases 2 and 3: segment, then migrate in parallel ----------------------
b = Seq([("mc",  ["Migration", "Controller"]),
         ("db",  ["Migration", "database"]),
         ("seg", ["Segmentizer"]),
         ("rp",  ["Rule", "Processor"]),
         ("tsa", ["Target System", "Adapter"])], height=450)
b.bar("mc", 100, 300)
b.bar("seg", 112, 176)
b.bar("db", 130, 176)
b.msg("mc", "seg", 112, "start()", lx=280)
b.msg("seg", "db", 146, "segmentize")
b.destroy("seg", 176)

b.msg("mc", "rp", 218, "start()", lx=330)
b.raw('<path d="M266,238 L{},238 L{},420 L266,420 z" fill="none" stroke="#2f7a4f" '
      'stroke-width="1.6"/>'.format(b.w - 26, b.w - 26))
b.raw('<path d="M266,238 L512,238 L512,268 L490,288 L266,288 z" fill="#f2f7f3" '
      'stroke="#2f7a4f" stroke-width="1.6"/>')
b.raw(f'<text x="280" y="261" font-size="{FS}" fill="#1f5637">parallel and repeated,</text>')
b.raw(f'<text x="280" y="281" font-size="{FS}" fill="#1f5637">until all data is migrated</text>')
b.bar("rp", 306, 412)
b.bar("db", 324, 356)
b.bar("tsa", 380, 412)
b.msg("rp", "db", 334, "getPackage")
b.selfmsg("rp", 352, "migrate package", drop=22, out=60)
b.msg("rp", "tsa", 400, "writePackage")
print(b.save("06-runtime-2.svg"), a.w)
