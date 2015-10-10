@doc """
An ORDFile object represents the information in an ORD format file like that
found on the VoteView website. It contains information about legislators and
their roll-call votes. The available information includes:

* congresses: To which Congress does the data belong?
* icpsr_ids: What is the ICPSR ID for the legislator?
* icpsr_states: What is the ICPSR state for the legislator?
* cds: What is the congressional district for the legislator?
* kh_states: What is the K/H state for the legislator?
* parties: What is the party for the legislator?
* unknowns: UNKNOWN PURPOSE COLUMN IN ORD FILE
* legislators: What is the name of the legislator?
* roll_call: The full roll-call from the ORD file stored as a RollCall object.

""" ->
immutable ORDFile{T1 <: Tuple, T2 <: Tuple, T3 <: Tuple, T4 <: Tuple}
    congresses::Vector{Int}
    icpsr_ids::Vector{Int}
    icpsr_states::Vector{Int}
    cds::Vector{Int}
    kh_states::Vector{UTF8String}
    parties::Vector{Int}
    unknowns::Vector{UTF8String}
    legislators::Vector{UTF8String}
    roll_call::RollCall{T1, T2, T3, T4}

    function ORDFile(
        congresses::Vector{Int},
        icpsr_ids::Vector{Int},
        icpsr_states::Vector{Int},
        cds::Vector{Int},
        kh_states::Vector{UTF8String},
        parties::Vector{Int},
        unknown::Vector{UTF8String},
        legislators::Vector{UTF8String},
        roll_call::RollCall{T1, T2, T3, T4},
    )
        n_legislators, n_bills = size(roll_call.votes)
        @assert length(congresses) == n_legislators
        @assert length(icpsr_ids) == n_legislators
        @assert length(icpsr_states) == n_legislators
        @assert length(cds) == n_legislators
        @assert length(kh_states) == n_legislators
        @assert length(parties) == n_legislators
        @assert length(unknown) == n_legislators
        @assert length(legislators) == n_legislators
        new(
            congresses,
            icpsr_ids,
            icpsr_states,
            cds,
            kh_states,
            parties,
            unknown,
            legislators,
            roll_call,
        )
    end
end

# Outer constructor necessary because of the inner constructor used for a
# parametric type.
function ORDFile{T1 <: Tuple, T2 <: Tuple, T3 <: Tuple, T4 <: Tuple}(
    congresses::Vector{Int},
    icpsr_ids::Vector{Int},
    icpsr_states::Vector{Int},
    cds::Vector{Int},
    kh_states::Vector{UTF8String},
    parties::Vector{Int},
    unknown::Vector{UTF8String},
    legislators::Vector{UTF8String},
    roll_call::RollCall{T1, T2, T3, T4},
)
    ORDFile{T1, T2, T3, T4}(
        congresses,
        icpsr_ids,
        icpsr_states,
        cds,
        kh_states,
        parties,
        unknown,
        legislators,
        roll_call,
    )
end

# Getter methods
congresses(ord_file::ORDFile) = ord_file.congresses
icpsr_ids(ord_file::ORDFile) = ord_file.icpsr_ids
icpsr_states(ord_file::ORDFile) = ord_file.icpsr_states
cds(ord_file::ORDFile) = ord_file.cds
kh_states(ord_file::ORDFile) = ord_file.kh_states
parties(ord_file::ORDFile) = ord_file.parties
unknowns(ord_file::ORDFile) = ord_file.unknowns
legislators(ord_file::ORDFile) = ord_file.legislators
roll_call(ord_file::ORDFile) = ord_file.roll_call

# TODO: Make this a very low-memory streaming reader.
# NOTE: The use of numeric indexing into substrings only works because the data
#       is assumed to always be ASCII.
@doc """
Use this function to parse an ORDFile from an arbitrary IO object. Assumes that
the votes should be encoding using the default VoteView encoding for 'yea',
'nay', 'missing' and 'inactive' votes. If another encoding should be used,
this must be passed as a third argument.
""" ->
function Base.read(
    ::Type{ORDFile},
    io::IO,
    encoding::RollCallEncoding = RollCallEncoding(),
)
    congresses = Int[]
    icpsr_ids = Int[]
    icpsr_states = Int[]
    cds = Int[]
    kh_states = UTF8String[]
    parties = Int[]
    unknown = UTF8String[]
    legislators = UTF8String[]
    votes = Int[]

    n_legislators = 0
    n_bills = 0

    while !eof(io)
        line = chomp(readline(io))

        n_legislators += 1
        n_bills = length(line) - 36

        # Parse the Congressional session.
        push!(congresses, parse(Int, line[1:3]))

        # Parse the ICPSR legislator code.
        push!(icpsr_ids, parse(Int, line[4:8]))

        # Parse the ICPSR state code.
        push!(icpsr_states, parse(Int, line[9:10]))

        # Parse the congressional district.
        push!(cds, parse(Int, line[11:12]))

        # Parse the Keith/Howard state code.
        push!(kh_states, rstrip(line[13:20]))

        # Parse the party code.
        push!(parties, parse(Int, line[21:23]))

        # TODO: Figure out what this is.
        push!(unknown, line[24:25])

        # Parse the legislator name.
        push!(legislators, rstrip(line[26:36]))

        # Parse the votes for this legislator.
        for j in 1:n_bills
            push!(votes, parse(Int, line[36 + j]))
        end
    end

    return ORDFile(
        congresses,
        icpsr_ids,
        icpsr_states,
        cds,
        kh_states,
        parties,
        unknown,
        legislators,
        RollCall(
            transpose(reshape(votes, n_bills, n_legislators)),
            encoding,
        ),
    )
end
