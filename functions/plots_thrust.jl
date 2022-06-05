using Plots

function plot_thrustcurve(time::Time,thrust::Thrust,filename::String)
    dt      = time.data[2]-time.data[1]
    ids     = argmin(abs.(time.data.-time.work_start))
    ide     = argmin(abs.(time.data.-time.work_end))
    tshift  = time.work_start
    x_time  = time.data[ids:ide].-tshift
    y_thrust= thrust.data[ids:ide]
    @assert length(x_time)==length(y_thrust)
    plt     = plot(x_time,y_thrust,label=false)

    plt=scatter!([time.max_thrust-tshift],[thrust.max],color="red",label="max_thrust")
    sm = @sprintf(" %.2f",thrust.max)
    plt=annotate!([time.max_thrust-tshift],[thrust.max],text(sm,:left,8,:red))
    
    ss = @sprintf(" %.2f",thrust.stem)
    plt=scatter!([time.stem-tshift],[thrust.stem],color="blue",label="stem")
    plt=annotate!([time.stem-tshift],[thrust.stem],text(ss,:left,8,:blue))
    
    st = @sprintf("%.2f",time.work_end-time.work_start)
    plt= scatter!([time.work_end-tshift],[y_thrust[end]],label=false,color=:black,shape=:rect)
    plt= annotate!([time.work_end-tshift],[y_thrust[end]],text(st,:bottom,8,:black))

    plt= xlabel!("time[s]")
    plt= ylabel!("thrust[N]")


    display(plt)
    savefig(plt,filename)
end

function plot_thrustcurve(time::Time,thrust::Thrust,coef::AbstractFloat,offset::AbstractFloat)

    p=plot((time.data),coef.*(thrust.data).+offset,
        xlabel="Time[s]",ylabel="Thrust[N]",title="Thrust_curve(Calibration)",label=false)
    display(p)
end

"""
    お好みの時間範囲でプロット
"""
function plot_thrustcurve(time::Time,thrust::Thrust,time_range::Tuple)
    tt = filter(x-> time_range[1]<=x<=time_range[2],time.data)
    th = thrust.data[findall(x-> time_range[1]<=x<=time_range[2],time.data)]

    println("time range:",time_range)
    p=plot(tt,th,
    xlabel="Time[s]",ylabel="Thrust[N]",title="Thrust(Calibration,in my range)",label=false)
    display(p)
end

"""
生データをプロット
"""
function plot_thrustcurve(data::Data)
    p=plot(data.time,data.thrust,
        xlabel="Time[-]",ylabel="Thrust[-]",Title="rawdata(thrust)")
    display(p)
end


