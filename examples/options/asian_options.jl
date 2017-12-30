using Miletus
using Base.Dates

evaluation = Date("2017-08-31")
maturity = Date("2017-11-30")
volatility = 0.27
spot = 16545.
strike = 16550.
risk_free = 0.
dividend = 0.

asian_call = AsianFixedStrikeCall(maturity, SingleStock(), Dates.Day(90), strike)
m = GeomBMModel(evaluation, spot, risk_free, dividend, volatility)
mcm = montecarlo(m, evaluation:maturity, 100_000)

npv = value(mcm, asian_call)
#Δ = delta(mcm, asian_call)

println(npv)
