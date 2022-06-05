include("./math.jl")
using Plots
using Printf

""" 
 compute work time , based on threshold_worktime
"""
function calc_worktime(time::Time,thrust::Thrust,input::Input; splot::Bool)
    println("\n-----------------")
    println("compute work time")
    println("-----------------")
    @show splot
    @show threshold = input.threshold_worktime

    # max推力＊5%以上のデータだけフィルタリング
        th_filtered = filter(x-> x>thrust.max * threshold, thrust.data)
        time_filtered = time.data[findall(thrust.data .> thrust.max * threshold)]

    # 作動時間の計算
        time.work_start = minimum(time_filtered)
        time.work_end   = maximum(time_filtered)
        work_time    = time.work_end-time.work_start

    # plot
    if splot 
        plt=plot(time_filtered,th_filtered,
                label=false,
                xlabel="time[s]",ylabel="thrust[N]",
                title="thrust(calib.) in worktime")
        plt=scatter!([time.max_thrust],[thrust.max],color="red",label="max_thrust")
        sm = @sprintf(" %.2f",thrust.max)
        plt=annotate!([time.max_thrust],[thrust.max],text(sm,:left,8,:red))
        
        ss = @sprintf(" %.2f",thrust.stem)
        plt=scatter!([time.stem],[thrust.stem],color="blue",label="stem")
        plt=annotate!([time.stem],[thrust.stem],text(ss,:left,8,:blue))
        display(plt)
        savefig(plt,input.workdir*"worktime_thrust_curve.pdf")
    end

    return work_time
end

function calc_totalimpulse(t::Time,th::Thrust,input::Input; mode)
    println("\n-----------------")
    println("compute total impulse")
    println("-----------------")

    threshold = input.threshold_worktime
    work_time = t.work_end-t.work_start

    thrust = th.data
    th_filtered = filter(x-> x>th.stem * threshold, thrust)

    if mode == "Mean"
        @show mode
        fave = mean(th_filtered)
        total_impulse = fave * work_time
    elseif mode == "Integral"
        @show mode
        timerange = (t.work_start,t.work_end)
        total_impulse=integral_trapezoid(t,th,timerange)
    end

    @show total_impulse
    return total_impulse
end