module TestZeroOneRollCall
    using Base.Test
    import RollCallDataIO

    encoding = RollCallDataIO.RollCallEncoding()
    votes = [1 2 3; 4 5 6; 7 8 9; 0 0 0]
    roll_call = RollCallDataIO.RollCall(votes, encoding)

    @test RollCallDataIO.transcode(1, encoding) === 1.0
    @test RollCallDataIO.transcode(2, encoding) === 1.0
    @test RollCallDataIO.transcode(3, encoding) === 1.0
    @test RollCallDataIO.transcode(4, encoding) === 0.0
    @test RollCallDataIO.transcode(5, encoding) === 0.0
    @test RollCallDataIO.transcode(6, encoding) === 0.0
    @test isnan(RollCallDataIO.transcode(7, encoding))
    @test isnan(RollCallDataIO.transcode(8, encoding))
    @test isnan(RollCallDataIO.transcode(9, encoding))
    @test isnan(RollCallDataIO.transcode(0, encoding))

    new_roll_call = convert(RollCallDataIO.ZeroOneRollCall, roll_call)
    @test isa(new_roll_call, RollCallDataIO.ZeroOneRollCall)

    new_votes = new_roll_call.votes
    @test size(new_votes) === (4, 3)

    @test new_votes[1, 1] === 1.0
    @test new_votes[1, 2] === 1.0
    @test new_votes[1, 3] === 1.0

    @test new_votes[2, 1] === 0.0
    @test new_votes[2, 2] === 0.0
    @test new_votes[2, 3] === 0.0

    @test isnan(new_votes[3, 1])
    @test isnan(new_votes[3, 2])
    @test isnan(new_votes[3, 3])

    @test isnan(new_votes[4, 1])
    @test isnan(new_votes[4, 2])
    @test isnan(new_votes[4, 3])
end
