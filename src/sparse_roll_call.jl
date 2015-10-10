@doc """
A SparseRollCall object is a variant of the ZeroOneRollCall encoding that
does not explicitly represent any of the missing or inactive votes. This
can be more efficient for model fitting since the missing and inactive notes
are ignored by many models.
""" ->
immutable SparseRollCall
    n_legislators::Int
    n_bills::Int
    legislators::Vector{Int}
    bills::Vector{Int}
    votes::Vector{Float64}
end

@doc """
Convert a RollCall object into a SparseRollCall object.
""" ->
function Base.convert(::Type{SparseRollCall}, roll_call::RollCall)
    encoding, old_votes = roll_call.encoding, roll_call.votes
    n_legislators, n_bills = size(old_votes)
    count_nans = 0
    for vote in old_votes
        count_nans += ifelse(isnan(transcode(vote, encoding)), 1, 0)
    end
    count_not_nans = length(old_votes) - count_nans
    legislators = Array(Int, count_not_nans)
    bills = Array(Int, count_not_nans)
    votes = Array(Float64, count_not_nans)
    i = 0
    for l in 1:n_legislators
        for b in 1:n_bills
            vote = transcode(old_votes[l, b], encoding)
            if !isnan(vote)
                i += 1
                legislators[i] = l
                bills[i] = b
                votes[i] = vote
            end
        end
    end
    SparseRollCall(n_legislators, n_bills, legislators, bills, votes)
end
