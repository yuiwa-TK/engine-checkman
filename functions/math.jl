using Statistics

"""
台形公式による数値積分（for calc_totalimpulse)
"""
function integral_trapezoid(time::Time,thrust::Thrust,time_range)
    tt = filter(x-> time_range[1]<=x<=time_range[2],time.data)
    th = thrust.data[findall(x-> time_range[1]<=x<=time_range[2],time.data)]
    dt = (time_range[2]-time_range[1])/length(tt)

    sumv = 0
    for i=1:length(tt)-1
        fm = th[i]
        fp = th[i+1]
        sumv += dt*(fp+fm)/2
    end

    return sumv
end

"""
移動平均
"""
function sma(a::Array, n::Int)
    vals = zeros(size(a,1) - (n-1), size(a,2))

    for i in 1:size(a,1) - (n-1)
        for j in 1:size(a,2)
            vals[i,j] = mean(a[i:i+(n-1),j])
        end
    end

    vals
end