pro irbem_make_lstar, io=io

lib_name = io.lib_name
ntime = io.ntime
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

;outputs
lm = io.lm
lstar = io.lstar
blocal = io.blocal
bmin = io.bmin
xj = io.xj
mlt = io.mlt

result = call_external(lib_name, 'make_lstar_', ntime,kext,options,sysaxes,iyear,idoy,ut, x1,x2,x3, maginput, lm,lstar,blocal,bmin,xj,mlt, /f_value)

io.lm = lm
io.lstar = lstar
io.blocal = blocal
io.bmin = bmin
io.xj = xj
io.mlt = mlt

end
