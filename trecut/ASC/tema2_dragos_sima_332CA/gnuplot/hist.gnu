#!/usr/bin/gnuplot

reset
set key at graph 0.29, 0.85 vertical samplen 1
set style data histogram
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 0.8
set ytics nomirror;

set yrange [0:2.5]; set xrange [-0.5:2.5]
set y2label 'Time (sec)' offset -0.5
set xlabel ' '
set size 0.9, 1
set label 1 'Processor Type' at graph 0.4, -0.1
set label 2 'simple_dsymv' at graph 0.29, 0.825
set label 3 'cblas_dsymv' at graph 0.29, 0.775
set label 4 'optim_dsymv' at graph 0.29, 0.725

set terminal png
set output 'test.png'
p 'hist.dat' u 2 title ' ', '' u 3 title ' ', '' u 4 title ' ', '' u 0:(0):xticlabel(1) w l title ''
