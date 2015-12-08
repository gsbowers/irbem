pro _crib_trace_field_line

;make irbem input/output structure
io = irbem_struct(ntime=1l)

;already set by default, but didatic 
io.ntime = 1l
io.kext = 4l
io.options = [0l,1l,0l,0,0l]
io.sysaxes = 0l     ;alt, lat, lon
io.iyear(*) = 2014l 
io.idoy(*) = 1l     
io.UT(*) = 0.0d     
io.x1(0) = 1000.0d     ;alt km
io.x2(0) = 30.0d     	;lat deg
io.x3(0) = 90.0d     	;lon deg
io.maginput[0] = 20.0d ;kp index 0<kp_noaa<90
io.r0 = 1.0d

irbem_trace_field_line, io=io

posit = io.posit
nposit = io.nposit

;plot projections of posit using tdas plotxy
thm_graphics_config
plotxy, transpose(posit(*,0:nposit-1)), versus='xy', multi='3,1'
plotxy, transpose(posit(*,0:nposit-1)), versus='xz', /addpanel
plotxy, transpose(posit(*,0:nposit-1)), versus='yz', /addpanel

end
