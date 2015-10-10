module TestSparseRollCall
    using Base.Test
    import RollCallDataIO

    encoding = RollCallDataIO.RollCallEncoding()
    votes = [1 0 0; 0 6 6;]
    roll_call = RollCallDataIO.RollCall(votes, encoding)

    new_roll_call = convert(RollCallDataIO.SparseRollCall, roll_call)
    @test isa(new_roll_call, RollCallDataIO.SparseRollCall)

    @test new_roll_call.n_legislators === 2
    @test new_roll_call.n_bills === 3
    @test new_roll_call.legislators == Int[1, 2, 2]
    @test new_roll_call.bills == Int[1, 2, 3]
    @test new_roll_call.votes == Int[1, 0, 0]
end
