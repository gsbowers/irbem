pro irbem_get_bderivs, io=io

lib_name = io.lib_name

ntime = io.ntime
kext = io.kext
options = io.options
sysaxes = io.sysaxes
dx = io.dx
iyear = io.iyear
idoy = io.idoy
ut = io.ut
x1 = io.x1
x2 = io.x2
x3 = io.x3
maginput = io.maginput

;outputs must be passed in
bgeo = io.bgeo
bmag = io.bmag
gradbmag = io.gradbmag
diffb = io.diffb

result = call_external(lib_name, 'get_bderivs_idl_', ntime, kext, options, $
  sysaxes,dx,iyear,idoy,UT,x1,x2,x3,maginput,Bgeo,Bmag,gradBmag,diffB)

;replace bad values with !Values.NAN
io.bgeo = bgeo
io.bmag = bmag
io.gradBmag = gradbmag
io.diffB = diffB

end
