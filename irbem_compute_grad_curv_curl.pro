pro irbem_compute_grad_curv_curl, io=io

;inputs
lib_name = io.lib_name
ntime = io.ntime
Bgeo = io.bgeo
Bmag = io.bmag
gradBmag = io.gradBmag
diffB = io.diffB

;outputs must be present
grad_par = io.grad_par 
grad_perp = io.grad_perp 
grad_drift = io.grad_drift 
curvature = io.curvature 
Rcurv = io.Rcurv 
curv_drift = io.curv_drift 
curlB = io.curlB 
divB =  io.divB 

result = call_external(lib_name, 'compute_grad_curv_curl_idl_',ntime,Bgeo,Bmag,gradBmag,diffB, grad_par,grad_perp,grad_drift,curvature,Rcurv,curv_drift,curlB,divB, /f_value)

;outputs
io.grad_par = grad_par
io.grad_perp = grad_perp
io.grad_drift = grad_drift
io.curvature = curvature
io.Rcurv = Rcurv
io.curv_drift = curv_drift
io.curlB = curlB
io.divB = divB

end
