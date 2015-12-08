pro _crib_get_bderivs

;make irbem input/output structure
io = irbem_struct(ntime=1l)

;some already set by default, but didatic 
io.ntime = 1l
io.kext = 4l
io.options = [0l,1l,0l,0l,0l]
io.sysaxes = 0l ;alt, lat, lon
io.iyear(*) = 2014l    ;sets all values in array
io.idoy(*) = 1l        ;sets all values in array
io.UT(*) = 0.0d        ;sets all values in array
io.x1(0) = 1000.0d     ;alt km
io.x2(0) = 30.0d     	;lat deg
io.x3(0) = 90.0d     	;lon deg
io.maginput[0] = 20.0d ;kp index 0<kp_noaa<90
io.r0 = 1.0d

;get field line coordinates at x1,x2,x3 from trace field line
irbem_trace_field_line, io=io

;get io ready to pass to get_bderivs
nposit = io.nposit
posit = io.posit

io.ntime = nposit 
io.x1 = reform(posit(0,*))
io.x2 = reform(posit(1,*))
io.x3 = reform(posit(2,*))
io.dX = double(1d-3)
;change coordinate system to GEO
io.sysaxes = 1l

;get derivs along field line
irbem_get_bderivs, io=io

Bgeo = io.bgeo[*,0:nposit-1]
Bmag = io.bmag[0:nposit-1]
grdadBmag = io.gradbmag[*,0:nposit-1]
diffB = io.diffB[*,*,0:nposit-1]

thm_graphics_config
;compare B computed from get_bderivs with trace_field_line
plot, bmag, ytit='B-Field [nt]', thick=2 
oplot, io.blocal, color=6

stop

end
