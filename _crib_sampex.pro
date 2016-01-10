pro _crib_sampex, T89=T89

io = irbem_struct(ntime=1l)

;already set by default
if keyword_set(T89) then begin
	model = 'IGRF+T89'
	io.kext = 4l
endif else begin
	model = 'IGRF'
	io.kext = 0l
endelse 

io.ntime = 1l 
io.options = [0l,1l,0l,0,0l]
io.sysaxes = 0l
io.iyear(*) = 1992l
io.idoy(*) = 190d
io.UT(*) = 19954.4d
io.x1(0) = 8.3931462d ;alt
;io.x2(0) = 65.569d ;SAMPEX lat
;io.x3(0) = 349.39527d ;SAMPEX lon
io.x2(0) = -66.917128d ;conj lat
io.x3(0) = 44.508681d ;conj lon
io.maginput[0] = 7.0d;kp index 0<kp_noaa<90

irbem_make_lstar, io=io

print, string(f='(%"%-10s:  L: %g MLT: %g")',model, io.lm(0), io.mlt(0))

end
