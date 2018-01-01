using Miletus
using DataFrames
using Base.Dates

import Miletus: Give, Both

evaluation = Date("2018-01-01")
maturity = Date("2018-01-31")

strangle_width = 400.
lower_protect_area = 800.
upper_protect_area = 600.

spot = 14400.
lower_strike = 14000.
lower_bound = lower_strike - lower_protect_area
upper_strike = lower_strike + strangle_width
upper_bound = upper_strike + upper_protect_area

volatility = 0.3
risk_free = 0.
dividend = 0.

# Contracts definition
call1 = EuropeanCall(maturity, SingleStock(), upper_strike)
call2 = EuropeanCall(maturity, SingleStock(), upper_bound)
put1 = EuropeanPut(maturity, SingleStock(), lower_strike)
put2 = EuropeanPut(maturity, SingleStock(), lower_bound)

contract = Both(Both(call1, put1), Give(Both(call2, put2)))

# Evaluation
gbmm = GeomBMModel(evaluation, spot, risk_free, dividend, volatility)
npv = value(gbmm, contract)
Δ = delta(gbmm, contract)

# Scenario Analysis
spot_scenarios = [13000., 13500., 14000., 14500., 15000.]
vol_scenarios = [0.20, 0.30, 0.40, 0.50]

price_table = zeros(Float64, size(spot_scenarios, 1), size(vol_scenarios, 1))

for (i, spot) in enumerate(spot_scenarios)
    for (j, vol) in enumerate(vol_scenarios)
        gbmm = GeomBMModel(maturity, spot, risk_free, dividend, vol)
        price_table[i, j] = value(gbmm, contract)
    end
end

df = DataFrame(price_table)
names!(df, [Symbol("vol - $v") for v in vol_scenarios])
df[:spot] = spot_scenarios
println(df)
