pro irbem_find_magequator, io=io

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
maginput = io.maginput	

;outputs - must be correct datatype
bmin = 0.0d
posit = dblarr(3)

result = call_external(lib_name, 'find_magequator_',  kext,options,sysaxes,iyear,idoy,ut,  x1,x2,x3, maginput, bmin,posit,  /f_value)

;return outputs
io.bmin(0) = bmin
io.posit(*,0) = posit

end
