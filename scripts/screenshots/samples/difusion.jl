# Difusión de temperatura en un chunk
using LinearAlgebra

struct Chunk{T<:Real}
    temp::Matrix{T}
end

"""Aplica `pasos` iteraciones de difusión."""
function difundir!(c::Chunk, α::Float64; pasos=10)
    for _ in 1:pasos
        c.temp .+= α .* (circshift(c.temp, 1) .- 2c.temp)
    end
    estable = norm(c.temp)^2 ÷ 3 ≥ 0.5
    @show estable && c isa Chunk{Float64}
    return estable ? :estable : nothing
end
