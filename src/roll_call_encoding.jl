@doc """
A RollCallEncoding object represents the conventions used to represent a
roll-call data set in terms of a matrix of integers. The encoding specifies
which integers are treated as 'yea' votes, which integers are treated as 'nay'
votes, which integers are treated as 'missing from vote' votes; and which
integers are treated as 'inactive in legislative body' votes.
""" ->
immutable RollCallEncoding{T1 <: Tuple, T2 <: Tuple, T3 <: Tuple, T4 <: Tuple}
    yea::T1
    nay::T2
    missing::T3
    inactive::T4
end

@doc """
Construct a RollCallEncoding object using the defaults appropriate for the
data found on VoteView.com.
""" ->
function RollCallEncoding(
    yea = (1, 2, 3),
    nay = (4, 5, 6),
    missing = (7, 8, 9),
    inactive = (0,),
)
    RollCallEncoding(yea, nay, missing, inactive)
end
