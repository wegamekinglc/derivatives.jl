using Gadfly
using Interpolations
using DataFrames

f̄ = [0.1, 0.0, -0.1]
σ₀ = [0.3, 0.3, 0.3]
C = [1. 0.5 0.5; 0.5 1. 0.5; 0.5 0.5 1.]

Σ = diagm(σ₀, 0) * C * diagm(σ₀, 0)

function full_invest(Σ, f̄, λ)
    ī = ones(f̄)
    s1 = ī' * Σ^-1 * ī
    s2 = ī' * Σ^-1 * f̄
    w̄ = Σ^-1 * ī / s1 + (s1 * Σ^-1 * f̄ - s2 * Σ^-1 * ī) / λ / s1
    μ = f̄' * w̄
    σ = sqrt(w̄' * Σ * w̄)
    μ, σ
end

function long_short(Σ, f̄, λ)
    ī = ones(f̄)
    s1 = ī' * Σ^-1 * ī
    s2 = ī' * Σ^-1 * f̄
    w̄ = (s1 * Σ^-1 * f̄ - s2 * Σ^-1 * ī) / λ / s1
    μ = f̄' * w̄
    σ = sqrt(w̄' * Σ * w̄)
    μ, σ
end

λs = exp.(log(100):-0.01:log(1.))

μ1 = zeros(λs)
σ1 = zeros(λs)
μ2 = zeros(λs)
σ2 = zeros(λs)

df_values = zeros(Float64, size(λs, 1), 4)

for (i, λ) in enumerate(λs)
    μ, σ = full_invest(Σ, f̄, λ)
    df_values[i, 1] = μ
    df_values[i, 2] = σ

    μ, σ = long_short(Σ, f̄, λ)
    df_values[i, 3] = μ
    df_values[i, 4] = σ
end

df1 = DataFrame(
    σ=df_values[:, 2],
    μ=df_values[:, 1],
    style="fully invested"
)

df2 = DataFrame(
    σ=df_values[:, 4],
    μ=df_values[:, 3],
    style="long short"
)

df = vcat(df1, df2)
fig = plot(df, x=:σ, y=:μ, color=:style, Geom.line)
