# This example is only a approximation of barrier option

push!(LOAD_PATH, Base.source_dir())

using Miletus
using Gadfly
using DataFrames
using Base.Dates
using utilities

import Miletus: EuropeanCall, Scale, Both, Give

maturity = Date("2018-06-30")
evaluation = Date("2018-01-01")

spot = 1.0
strike = 1.0
barrier = 1.5
p_gap = barrier - strike

multiplyer = 2.
x_gap = p_gap / (multiplyer - 1.)

call1 = EuropeanCall(maturity, SingleStock(), strike)
call2 = Scale(multiplyer, EuropeanCall(maturity, SingleStock(), barrier))
call3 = Scale(multiplyer - 1., EuropeanCall(maturity, SingleStock(), barrier + x_gap))

contract = Both(Both(call1, Give(call2)), call3)

prices = spot - 0.98:0.001:spot + 1.5
xs, ys = utilities.payoff_curve(contract, maturity, prices)

payoffs = DataFrame(spot=xs, payoff=ys)

volatility = 0.3
risk_free = 0.
dividend = 0.

gbmm = GeomBMModel(evaluation, spot, risk_free, dividend, volatility)

npv = value(gbmm, contract)
println(npv)

delta_ = delta(gbmm, contract)
println(delta_)
