abstract type ParamterType end

mutable struct Input <:ParamterType
    workdir::String    # directory name that contains "xxx.csv" file
    filename::String   # name of csv file that has raw data
    ch_thrust::Union{Int,Nothing}
    ch_pressure::Union{Int,Nothing}
    ch_temperature::Union{Int,Nothing}
    calibration_coef::Union{AbstractFloat,Nothing}
    calibration_offset::Union{AbstractFloat,Nothing}
    threshold_worktime::Union{AbstractFloat,Nothing}
    mode_thrustmax::Union{AbstractString,Nothing}
    refval_thrustmax::Union{AbstractFloat,Nothing}
    figname::Union{AbstractString,Nothing}

    Input()=new()
end

abstract type ResultType end
mutable struct RawData <:ResultType
    head       :: AbstractArray{String}
    condition  :: AbstractArray{String}
    time       :: AbstractArray{AbstractFloat}
    thrust     :: AbstractArray{AbstractFloat}
    # if you need
        # Pressure    :: AbstractArray{AbstractFloat}
        # Temperature :: AbstractArray{AbstractFloat}
        # Chdata :: AbstractArray{AbstractArray{AbstractFloat}}

    RawData() = new()
end

mutable struct Thrust{T<:AbstractFloat}  <:ResultType
    data::AbstractVector{T} #calibulated data
    max::T
    average::T
    stem::T

    Thrust{T}() where ({T<:AbstractFloat})=new()
end

mutable struct Time{T<:AbstractFloat}  <:ResultType
    data::AbstractVector{T} 
    work_start::T
    work_end::T
    max_thrust::T
    stem::T

    Time{T}() where ({T<:AbstractFloat})=new()
end