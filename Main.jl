include("./functions/variables.jl")
include("./functions/read_data.jl")
include("./functions/engine_property.jl")
include("./functions/find_stem_and_max.jl")
include("./functions/plots_thrust.jl")
include("stdin")

function initialize()
    #input
    input= read_input()
    @show input
        
    #constructor "data", "time", "thrust"
        data  = read_rawdata(input)
        time  = Time{Float64}()
        thrust= Thrust{Float64}()

    # 初期値の代入
        time.data        = data.time
        thrust.data      = input.calibration_coef.*(data.thrust)
                         .+input.calibration_offset
    return input,data,time,thrust
end

println("\n==========================================")
println(" Initialize(readfiles) & plot raw data")
println("===========================================")
@time   input,data,time,thrust=initialize();

# max thrustをどうやって求めるかの条件分岐（詳細は"find_stem_and_max.jl"へ)
if input.mode_thrustmax === nothing
        # 生データのプロット
        plot_thrustcurve(data);
        message="最大推力を求めるアルゴリズムのmode(∈[tol,thrust,stemcut])を入力してね[Enterで確定]\n
                ([note]１度数字を入力しても進まない時は，もう一度同じ数を入力してね)"
        input.mode_thrustmax=Base.prompt(message)
        message="その際の参照値を入力してね"
        input.refval_thrustmax=parse(Float64,Base.prompt(message))

        @show input.mode_thrustmax,input.refval_thrustmax
else
        @show input.mode_thrustmax,input.refval_thrustmax
end

println("\n==========================================")
println(" Data Processing...")
println("===========================================")
        find_stem_and_maxthrust(time,thrust,
                                mode=input.mode_thrustmax,refval=input.refval_thrustmax)
        calc_worktime(time,thrust,input,splot=true);
        calc_totalimpulse(time,thrust,input; mode="Integral") #mode ∈["Mean","Integral"]


println("\n==========================================")
println(" plot thrst curve ")
println("===========================================")
        @show input.calibration_coef,input.calibration_offset
        @show filename = input.workdir*input.figname
        plot_thrustcurve(time,thrust,filename)
