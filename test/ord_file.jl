module TestORDFile
    using Base.Test
    import RollCallDataIO

    path = joinpath(dirname(@__FILE__), "data", "senate113.ord")
    io = open(path, "r")
    ord_file = RollCallDataIO.read(RollCallDataIO.ORDFile, io)
    close(io)

    @test isa(ord_file, RollCallDataIO.ORDFile)

    roll_call = RollCallDataIO.roll_call(ord_file)
    @test isa(roll_call, RollCallDataIO.RollCall)

    @test isa(roll_call.votes, Matrix{Int})
    n_legislators, n_bills = size(roll_call.votes)

    @test isa(RollCallDataIO.congresses(ord_file), Vector{Int})
    @test length(RollCallDataIO.congresses(ord_file)) == n_legislators
    @test all(RollCallDataIO.congresses(ord_file) .== 113)

    @test isa(RollCallDataIO.icpsr_ids(ord_file), Vector{Int})
    @test length(RollCallDataIO.icpsr_ids(ord_file)) == n_legislators
    @test RollCallDataIO.icpsr_ids(ord_file)[1] == 99911
    @test RollCallDataIO.icpsr_ids(ord_file)[2] == 49700
    @test RollCallDataIO.icpsr_ids(ord_file)[3] == 94659
    @test RollCallDataIO.icpsr_ids(ord_file)[104] == 29940
    @test RollCallDataIO.icpsr_ids(ord_file)[105] == 49706
    @test RollCallDataIO.icpsr_ids(ord_file)[106] == 40707

    @test isa(RollCallDataIO.icpsr_states(ord_file), Vector{Int})
    @test length(RollCallDataIO.icpsr_states(ord_file)) == n_legislators
    @test RollCallDataIO.icpsr_states(ord_file)[1] == 99
    @test RollCallDataIO.icpsr_states(ord_file)[2] == 41
    @test RollCallDataIO.icpsr_states(ord_file)[3] == 41
    @test RollCallDataIO.icpsr_states(ord_file)[104] == 25
    @test RollCallDataIO.icpsr_states(ord_file)[105] == 68
    @test RollCallDataIO.icpsr_states(ord_file)[106] == 68

    @test isa(RollCallDataIO.cds(ord_file), Vector{Int})
    @test length(RollCallDataIO.cds(ord_file)) == n_legislators
    @test RollCallDataIO.cds(ord_file)[1] == 0
    @test RollCallDataIO.cds(ord_file)[2] == 0
    @test RollCallDataIO.cds(ord_file)[3] == 0
    @test RollCallDataIO.cds(ord_file)[104] == 0
    @test RollCallDataIO.cds(ord_file)[105] == 0
    @test RollCallDataIO.cds(ord_file)[106] == 0

    @test isa(RollCallDataIO.kh_states(ord_file), Vector{UTF8String})
    @test length(RollCallDataIO.kh_states(ord_file)) == n_legislators
    @test RollCallDataIO.kh_states(ord_file)[1] == "USA"
    @test RollCallDataIO.kh_states(ord_file)[2] == "ALABAMA"
    @test RollCallDataIO.kh_states(ord_file)[3] == "ALABAMA"
    @test RollCallDataIO.kh_states(ord_file)[104] == "WISCONS"
    @test RollCallDataIO.kh_states(ord_file)[105] == "WYOMING"
    @test RollCallDataIO.kh_states(ord_file)[106] == "WYOMING"

    @test isa(RollCallDataIO.parties(ord_file), Vector{Int})
    @test length(RollCallDataIO.parties(ord_file)) == n_legislators
    @test RollCallDataIO.parties(ord_file)[1] == 100
    @test RollCallDataIO.parties(ord_file)[2] == 200
    @test RollCallDataIO.parties(ord_file)[3] == 200
    @test RollCallDataIO.parties(ord_file)[104] == 100
    @test RollCallDataIO.parties(ord_file)[105] == 200
    @test RollCallDataIO.parties(ord_file)[106] == 200

    # TODO: Figure out what this field really is
    RollCallDataIO.unknowns(ord_file)

    @test isa(RollCallDataIO.legislators(ord_file), Vector{UTF8String})
    @test length(RollCallDataIO.legislators(ord_file)) == n_legislators
    @test RollCallDataIO.legislators(ord_file)[1] == "OBAMA"
    @test RollCallDataIO.legislators(ord_file)[2] == "SESSIONS"
    @test RollCallDataIO.legislators(ord_file)[3] == "SHELBY"
    @test RollCallDataIO.legislators(ord_file)[104] == "BALDWIN"
    @test RollCallDataIO.legislators(ord_file)[105] == "ENZI"
    @test RollCallDataIO.legislators(ord_file)[106] == "BARASSO"

    @test vec(roll_call.votes[1, 1:5]) == Int[9, 9, 9, 1, 1]
    @test vec(roll_call.votes[2, 1:5]) == Int[6, 6, 1, 6, 1]
    @test vec(roll_call.votes[3, 1:5]) == Int[6, 6, 6, 1, 1]
    @test vec(roll_call.votes[104, 1:5]) == Int[1, 1, 6, 1, 1]
    @test vec(roll_call.votes[105, 1:5]) == Int[1, 1, 1, 6, 1]
    @test vec(roll_call.votes[106, 1:5]) == Int[1, 1, 1, 6, 1]
end
