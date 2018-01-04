# This example is only a approximation of barrier option

push!(LOAD_PATH, Base.source_dir())

using Miletus
using Gadfly
using DataFrames
using Base.Dates
using utilities

import Miletus: EuropeanCall, Scale

maturity = Date("2018-06-30")
evaluation = Date("2018-01-01")

spot = 1.0
strike = 1.0
barrier = 1.5
p_gap = barrier - strike

multiplyer = 100.
x_gap = p_gap / (multiplyer - 1.)

call1 = EuropeanCall(maturity, SingleStock(), strike)
call2 = EuropeanCall(maturity, SingleStock(), barrier)
call3 = EuropeanCall(maturity, SingleStock(), barrier + x_gap)

prices = spot - 0.98:0.001:spot + 1.5
xs1, ys1 = utilities.payoff_curve(call1, maturity, prices)
xs2, ys2 = utilities.payoff_curve(call2, maturity, prices)
xs3, ys3 = utilities.payoff_curve(call3, maturity, prices)
ys = ys1 - multiplyer * ys2 + (multiplyer - 1.) * ys3

payoffs = DataFrame(spot=xs1, payoff=ys)

volatility = 0.3
risk_free = 0.
dividend = 0.

gbmm = GeomBMModel(evaluation, spot, risk_free, dividend, volatility)

npv1 = value(gbmm, call1)
npv2 = value(gbmm, call2)
npv3 = value(gbmm, call3)
npv = npv1 - multiplyer * npv2 + (multiplyer - 1.) * npv3
println(npv)

delta1 = delta(gbmm, call1)
delta2 = delta(gbmm, call2)
delta3 = delta(gbmm, call3)
delta_all = delta1 - multiplyer * delta2 + (multiplyer - 1.) * delta3
println(delta_all)
