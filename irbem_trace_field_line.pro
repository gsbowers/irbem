pro irbem_trace_field_line, io=io

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
R0 = io.R0

;outputs
lm = io.lm
blocal = io.blocal
bmin = io.bmin
XJ = io.xj
posit = io.posit
nposit = io.nposit 

result = call_external(lib_name, 'trace_field_line2_',  kext,options,sysaxes,iyear,idoy,ut,  x1,x2,x3,maginput,R0,lm,blocal,bmin,xj,posit,Nposit,  /f_value)

io.lm = lm
io.blocal = blocal
io.bmin = bmin
io.xj = xj
io.posit = posit
io.nposit = nposit

end
