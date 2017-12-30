using Miletus
using Base.Dates

maturity = Date("2016-01-15")
evaluation = Date("2015-05-08")
spot = 0.98
strike = 1.
volatility = 0.2
dividend = 0.05
risk_free = 0.02

eu_call = EuropeanCall(maturity, SingleStock(), strike)

gbmm = GeomBMModel(evaluation, spot, risk_free, dividend, volatility)
@time npv = value(gbmm, eu_call)
@time Δ = delta(gbmm, eu_call)
println(npv)
println(Δ)
