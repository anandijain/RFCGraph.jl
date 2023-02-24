using HTTP, Cascadia, Gumbo, Catlab, Downloads
using Catlab.Graphs, Catlab.Graphics, Catlab.CategoricalAlgebra
using ProgressMeter, Test

@acset_type IndexedLabeledGraph(Catlab.Graphs.SchLabeledGraph, index=[:src, :tgt],
    unique_index=[:label]) <: Catlab.Graphs.AbstractLabeledGraph

_data(s) = joinpath(@__DIR__, "../data/", s)
function goodbadt(f, xs; verbose=false)
    n = length(xs)
    p = Progress(n)

    good = []
    bad = []
    Threads.@threads for (i, x) in collect(enumerate(xs))
        verbose && @info x
        try
            y = f(x)
            push!(good, (i, x) => y)
        catch e
            push!(bad, (i, x) => (e, current_exceptions()))
        end
        next!(p)
    end
    good, bad
end

id_from_fn(a) = parse(Int, match(r"rfc(\d+)\.html$", a).captures[1])
is_rfc_href(x) = begin
    atr = x.attributes
    haskey(atr, "href") && startswith(x.attributes["href"], "./rfc")
end
a_to_id(a) = parse(Int, split(split(a.attributes["href"][6:end], "#")[1], ".")[1])

fns = filter(endswith(".html"), readdir(_data("RFC-all/"); join=true))
fns = sort(fns, by=x -> id_from_fn(x))
ids = id_from_fn.(fns)

rfc_outneighbors(fn) = begin
    s = read(fn, String)
    h = parsehtml(s)
    S = sel"a"
    as = eachmatch(S, h.root)
    aa = unique(filter(is_rfc_href, as))
    a_to_id.(aa)
end

gs, bs = goodbadt(rfc_outneighbors, fns);
@test length(gs) == 9151
g = Graph()
NV = maximum(ids)
Catlab.Graphs.add_vertices!(g, NV)
for (x, y) in gs
    src = id_from_fn(x[2])
    for tgt in y
        try
            Catlab.Graphs.add_edge!(g, src, tgt)
        catch
            @info src, tgt
        end
    end
end
mkpath("logs")
write_json_acset(g, "logs/rfc_graph.json")
