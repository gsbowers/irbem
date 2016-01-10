pro _crib_barrel

	probe = '1C'

	;timespan covering first compaign
	timespan, '2013-01-01', 60, /day
	barrel_load_data, probe=probe, datatype='GPS', version='v05' 
	noaa_load_kp

	;get data from tplot variables
	get_data, string(format='(%"brl%s_L_Kp2")', probe), data=l_data
	get_data, string(format='(%"brl%s_GPS_Lat")', probe), data=lat_data
	get_data, string(format='(%"brl%s_GPS_Lon")', probe), data=lon_data
	get_data, string(format='(%"brl%s_GPS_Alt")', probe), data=alt_data
	
	;get time
	t = alt_data.x
	
	;only finite values
	w = where(finite(t), count)
	
	;only 100000 values, size of IRBEM NTIME_MAX
	w = w[0:99999]
	t = t(w)
	lat = lat_data.y(w)
	lon = lon_data.y(w)
	alt = alt_data.y(w)
	lkp2 = l_data.y(w)
	
	io = irbem_struct(ntime=100000)

	io.ntime = 100000l
	io.options = [0l, 1l, 0l, 0, 0l]
	io.sysaxes = 0l
	io.iyear(*) = long(time_string(t, tformat='YYYY'))
	io.idoy(*) = long(time_string(t, tformat='DOY'))
	io.UT = double(t - gettime(time_string(t, tformat='YYYY-MM-DD')))
	io.x1(*) = double(alt)
	io.x2(*) = double(lat)
	io.x3(*) = double(lon)
	io.maginput[0,*] = 20.0d;kp index 0<kp_noaa<90

	irbem_make_lstar, io=io
	
	plot, t-t[0], abs(io.lm), yrange=[0,10]
	oplot, t-t[0], lkp2, color=2
	
	stop

end
