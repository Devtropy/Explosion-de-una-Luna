# animacion_3d_snapshots.gp

set terminal gif animate delay 1 loop 0 background rgb "black"
set output "anillos_saturno.gif"

set xrange [-2:2]     # Ajusta según tus datos
set yrange [-2:2]
set zrange [-2:2]

set view 60, 30         # Ángulo de vista en 3D
set size ratio 1
set border lw 1.5
set ticslevel 0

do for [i=1:10000:50] {
    filename = sprintf("frame_%05d.dat", i)
    splot filename using 1:2:3 with points pt 7 ps 0.5 lc rgb "white" notitle,\
          filename using 4:5:6 with points pt 7 ps 7 lc rgb "brown" notitle
}