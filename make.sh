#/bin/sh

pandoc --standalone -t beamer -V theme=Antibes --slide-level=2 nips2014yomi.md >nips2014yomi.tex

buf_size=2000000 platex nips2014yomi.tex

dvipdfmx -f texfonts.map nips2014yomi.dvi

