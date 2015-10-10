module TestRollCallEncoding
    using Base.Test
    import RollCallDataIO

    encoding1 = RollCallDataIO.RollCallEncoding()

    @test isa(encoding1, RollCallDataIO.RollCallEncoding)
    @test encoding1.yea === (1, 2, 3)
    @test encoding1.nay === (4, 5, 6)
    @test encoding1.missing === (7, 8, 9)
    @test encoding1.inactive === (0,)

    encoding2 = RollCallDataIO.RollCallEncoding(
        (1, 2),
        (3, 4),
        (5, 6),
        (7, 8, 9),
    )

    @test isa(encoding2, RollCallDataIO.RollCallEncoding)
    @test encoding2.yea === (1, 2)
    @test encoding2.nay === (3, 4)
    @test encoding2.missing === (5, 6)
    @test encoding2.inactive === (7, 8, 9)
end
