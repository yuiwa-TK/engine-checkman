"""
    find first peak(stem) and
    find second peak (max thrust)
"""
function find_stem_and_maxthrust(time::Time,thrust::Thrust; mode, refval)
    @show mode,refval
    
    #stem
    @show idstem= argmax(thrust.data)
    thrust.stem = thrust.data[idstem]
    time.stem   = time.data[idstem]
 
    #max thrust
    if mode =="stemcut" 
        # おすすめ，refval = 0.05s>sampling_dtくらいがいい？
        # time.stem+refval[s]のデータの中から最大を求める
        idleft          = argmin(abs.(time.data.-(time.stem+refval)))
        id_temp         = argmax(thrust.data[idleft:end])
        id_thrustmax    = idleft +id_temp -1
        thrust.max      = thrust.data[id_thrustmax]
        time.max_thrust = time.data[id_thrustmax]
        
    elseif mode == "tol"
        # stem脱落より後の時刻かつ，(stem_thrust-data)>tolとなるデータの中での最大をとる
        f=filter(x-> thrust.stem-x >refval,thrust.data[idstem+1:end])
        id_thrustmax = argmax(f)
        thrust.max      = thrust.data[id_thrustmax+idstem]
        time.max_thrust = time.data[id_thrustmax+idstem]

    elseif mode =="thrust"
        # おおよその最大推力を入力し，最も近いものを返す
        id_thrustmax    = argmin(abs.(thrust.data.-refval))
        thrust.max      = thrust.data[id_thrustmax]
        time.max_thrust = time.data[id_thrustmax]
    end
    return time.stem,thrust.stem,time.max_thrust,thrust.max
end

