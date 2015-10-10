module TestRollCall
    using Base.Test
    import RollCallDataIO

    encoding = RollCallDataIO.RollCallEncoding()
    votes = [1 2 3; 4 5 6; 7 8 9; 0 0 0]
    roll_call = RollCallDataIO.RollCall(votes, encoding)

    @test isa(roll_call, RollCallDataIO.RollCall)
    @test isa(roll_call.votes, Matrix{Int})
    @test isa(roll_call.encoding, RollCallDataIO.RollCallEncoding)
end
