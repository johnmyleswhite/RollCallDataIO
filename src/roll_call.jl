@doc """
A RollCall object represents a complete roll-call data set along with metadata
about the encoding used by the dataset. This encoding is stored in the form
of a RollCallEncoding object.
""" ->
immutable RollCall{T1 <: Tuple, T2 <: Tuple, T3 <: Tuple, T4 <: Tuple}
    votes::Matrix{Int}
    encoding::RollCallEncoding{T1, T2, T3, T4}
end
