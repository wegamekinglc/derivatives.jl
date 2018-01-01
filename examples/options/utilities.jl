module Utilities

using Miletus

function payoff_curve(c, d::Date, prices)
    payoff = [value(GeomBMModel(d, x, 0.0, 0.0, 0.0), c) for x in prices]
    p = [x for x in payoff]
    r = [x for x in prices]
    return r, p
end

end
