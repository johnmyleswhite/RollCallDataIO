module RollCallDataIO
    include("roll_call_encoding.jl")
    include("roll_call.jl")
    include("zero_one_roll_call.jl")
    include("sparse_roll_call.jl")
    include("ord_file.jl")
end
