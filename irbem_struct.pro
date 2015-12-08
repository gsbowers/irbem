function irbem_struct, ntime=ntime

if ~keyword_set(ntime) then ntime=1l

lib_name = '/home/gsbowers/irbem/irbem-code/source/onera_desp_lib_linux_x86_64.so'

;get ntime_max
ntime_max = 0l
result = call_external(lib_name, 'get_irbem_ntime_max_', ntime_max)
nalpha_max = 25l

;input/output structure to return
io = {lib_name:lib_name,$
      ntime_max:ntime_max,$
      ntime:ntime,$
      nalpha_max:nalpha_max,$
      alpha:dblarr(25l),$
      kext:0l,$
      options:lonarr(5),$ 
      sysaxes:0l,$
      dX:double(1e-3), $
      iyear:lonarr(ntime_max),$ 
      idoy:lonarr(ntime_max),$
      UT:dblarr(ntime_max), $
      x1:dblarr(ntime_max), x2:dblarr(ntime_max), x3:dblarr(ntime_max), $
      maginput:dblarr(25,ntime_max), $
      ;trace field line
      R0:0.0d,$
      Lm:dblarr(ntime_max),$
      Blocal:dblarr(ntime_max),$
      Bmin:dblarr(ntime_max),$
      XJ:dblarr(ntime_max),$
      Posit:dblarr(3,10000),$
      NPosit:0l,$
      ;get_bderivs outputs
      Bgeo:dblarr(3,ntime_max),$
      Bmag:dblarr(ntime_max),$
      gradBmag:dblarr(3,ntime_max),$
      diffB:dblarr(3,3,ntime_max),$
      ;compute_grad_curv_curl outputs
      grad_par:dblarr(ntime_max),$
      grad_perp:dblarr(3,ntime_max),$
      grad_drift:dblarr(3,ntime_max),$
      curvature:dblarr(3,ntime_max),$
      Rcurv:dblarr(3,ntime_max),$
      curv_drift:dblarr(ntime_max),$
      curlB:dblarr(3,ntime_max),$
      divB:dblarr(ntime_max)$
}

;defaults
;see manual downloaded at https://craterre.onecert.fr/prbem/irbem/description.html

;kext: long integer to select external magnetic field
;4   = Tsyganenko [1989c] (uses 0≤Kp≤9 - Valid for rGEO≤70. Re)
io.kext = 4l

;options: array(5) of long integer to set some control options on computed values
;options(1st element):  0 - don't compute L* or Φ ;  1 - compute L*; 2- compute Φ
io.options(0) = 0l
;options(2nd element): 0 - initialize IGRF field once per year (year.5);  n - n is the  frequency (in days) starting on January 1st of each year (i.e. if options(2nd element)=15 then IGRF will be updated on the following days of the year: 1, 15, 30, 45 ...)
io.options(1) = 1l
;options(3rd element): resolution to compute L* (0 to 9) where 0 is the recomended value to ensure a good ratio precision/computation time (i.e. an error of ~2% at L=6). The higher the value the better will be the precision, the longer will be the computing time. Generally there is not much improvement for values larger than 4. Note that this parameter defines the integration step (θ) along the field line such as dθ=(π)/(720*[options(3rd element)+1])
io.options(2) = 0l
;options(4th element): resolution to compute L* (0 to 9). The higher the value the better will be the precision, the longer will be the computing time. It is recommended to use 0 (usually sufficient) unless L* is not computed on a LEO orbit. For LEO orbit higher values are recommended. Note that this parameter defines the integration step (φ) along the drift shell such as dφ=(2π)/(25*[options(4th element)+1])
io.options(3) = 0l
;options(5th element): allows to select an internal magnetic field model (default is set to IGRF)
;0 = IGRF 
io.options(4) = 0l

;sysaxes, sysaxesIN, and sysaxesOUT: long integer to define which coordinate system is provided in
;0: GDZ (alti, lati, East longi - km,deg.,deg)
;1: GEO (cartesian) - Re
;2: GSM (cartesian) - Re
;3: GSE (cartesian) - Re
;4: SM (cartesian) - Re
;5: GEI (cartesian) - Re
;6: MAG (cartesian) - Re
;7: SPH (geo in spherical) - (radial distance, lati, East longi - Re, deg., deg.)
;8: RLL  (radial distance, lati, East longi - Re, deg., deg. - prefered to 7) 
sysaxes = 0l

; maginput: array (25,NTIME_MAX) of double to specify magnetic fields inputs such as:
;
;    maginput(1st element,*) =Kp: value of Kp as in OMNI2 files but has to be double instead of integer type. (NOTE, consistent with OMNI2, this is Kp*10, and it is in the range 0 to 90)
;    maginput(2nd element,*) =Dst: Dst index (nT)
;    maginput(3rd element,*) =dens: Solar Wind density (cm-3)
;    maginput(4th element,*) =velo: Solar Wind velocity (km/s)
;    maginput(5th element,*) =Pdyn: Solar Wind dynamic pressure (nPa)
;    maginput(6th element,*) =ByIMF: GSM y component of IMF mag. field (nT)
;    maginput(7th element,*) =BzIMF: GSM z component of IMF mag. field (nT)
;    maginput(8th element,*) =G1:  G1=< Vsw*(Bperp/40)2/(1+Bperp/40)*sin3(theta/2) > where the <> mean an average over the previous 1 hour, Vsw is the solar wind speed, Bperp is the transverse IMF component (GSM) and theta it's clock angle.
;    maginput(9th element,*) =G2: G2=< a*Vsw*Bs > where the <> mean an average over the previous 1 hour, Vsw is the solar wind speed, Bs=|IMF Bz| when IMF Bz < 0 and Bs=0 when IMF Bz > 0, a=0.005.
;    maginput(10th element,*) =G3:  G3=< Vsw*Dsw*Bs /2000.>
;    where the <> mean an average over the previous 1 hour, Vsw is the solar wind speed, Dsw is the solar wind density, Bs=|IMF Bz| when IMF Bz < 0 and Bs=0 when IMF Bz > 0.
;    maginput(11th element,*) =W1 see definition in (JGR-A, v.110(A3), 2005.) (PDF 1.2MB)
;    maginput(12th element,*) =W2 see definition in (JGR-A, v.110(A3), 2005.) (PDF 1.2MB)
;    maginput(13th element,*) =W3 see definition in (JGR-A, v.110(A3), 2005.) (PDF 1.2MB)
;    maginput(14th element,*) =W4 see definition in (JGR-A, v.110(A3), 2005.) (PDF 1.2MB)
;    maginput(15th element,*) =W5 see definition in (JGR-A, v.110(A3), 2005.) (PDF 1.2MB)
;    maginput(16th element,*) =W6 see definition in (JGR-A, v.110(A3), 2005.) (PDF 1.2MB)
;    maginput(17th element,*) =AL the auroral index
;    maginput(18th element,*) to maginput(25th element,*): for future use 

return, io 

end
