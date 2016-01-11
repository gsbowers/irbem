pro irbem_find_foot_point, io=io, xfoot, bfoot, bfootmag

;inputs
lib_name = io.lib_name
kext = io.kext
options = io.options
sysaxes = io.sysaxes
iyear = io.iyear
idoy = io.idoy
UT = io.UT
x1 = io.x1
x2 = io.x2
x3 = io.x3
stop_alt = io.stop_alt
hemi_flag = io.hemi_flag
maginput = io.maginput

;outputs
xfoot = dblarr(3)
bfoot = dblarr(3)
bfootmag = dblarr(3)

result = call_external(lib_name,  'find_foot_point_', kext,options,sysaxes,iyear,idoy,ut, x1,x2,x3,stop_alt,hemi_flag,maginput, xfoot,bfoot,bfootmag, /f_value)
	

end
