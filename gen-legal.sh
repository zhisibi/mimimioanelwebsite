#!/bin/sh
# 把 legal-src/*.md 生成网页。隐私政策或用户协议更新后：复制最新 md 到 legal-src/，再运行 sh gen-legal.sh
set -e
cd "$(dirname "$0")"
CSS='<style>body{max-width:760px;margin:0 auto;padding:24px 18px 60px;font:16px/1.75 -apple-system,"PingFang SC","HarmonyOS Sans SC","Microsoft YaHei",sans-serif;color:#222;background:#fff}h1{font-size:1.6em}h2{font-size:1.25em;margin-top:1.8em}a{color:#4f5bd5}table{border-collapse:collapse}td,th{border:1px solid #ddd;padding:4px 8px}.back{font-size:14px}@media(prefers-color-scheme:dark){body{background:#121212;color:#ddd}a{color:#9aa4ff}}</style>'
for p in legal-src/*.md; do
  f=$(basename $p .md); case $f in *.en) L=en; B='← Mimi Panel';; *) L=zh-CN; B='← 返回咪咪面板官网';; esac
  T=$(head -1 $p | sed 's/^# *//')
  pandoc $p -f gfm -t html5 -s --metadata lang=$L -V header-includes="$CSS" -V pagetitle="$T" -o $f.html 2>/dev/null
  python3 - $f.html "$B" <<'P'
import re,sys;p,b=sys.argv[1],sys.argv[2];s=open(p).read();s=re.sub(r'<header id="title-block-header">.*?</header>','',s,flags=re.S);s=s.replace('<body>','<body>\n<p class="back"><a href="./">'+b+'</a></p>',1);open(p,'w').write(s)
P
done
touch .nojekyll
