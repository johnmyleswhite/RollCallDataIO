@doc """
A ZeroOneRollCall object represents a roll call data-set in a format
appropriate for binary classification analysis: 'yea' votes are encoded as 1's;
'nay' votes are encoded as 0's; all other vote values are encoded as `NaN`.
""" ->
immutable ZeroOneRollCall
    votes::Matrix{Float64}
end

@doc """
Translate a single integer-valued vote from a RollCall object that uses the
provided `encoding` into the zero-one encoding used by the ZeroOneRollCall
type.
""" ->
function transcode(vote::Integer, encoding::RollCallEncoding)
    ifelse(
        vote in encoding.nay,
        0.0,
        ifelse(
            vote in encoding.yea,
            1.0,
            NaN
        )
    )
end

@doc """
Convert a RollCall object into a ZeroOneRollCall object.
""" ->
function Base.convert(::Type{ZeroOneRollCall}, roll_call::RollCall)
    encoding, old_votes = roll_call.encoding, roll_call.votes
    n_legislators, n_bills = size(old_votes)
    votes = Array(Float64, n_legislators, n_bills)
    for j in 1:n_bills
        for i in 1:n_legislators
            votes[i, j] = transcode(old_votes[i, j], encoding)
        end
    end
    ZeroOneRollCall(votes)
end
