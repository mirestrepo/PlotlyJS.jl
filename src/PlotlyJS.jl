module PlotlyJS

using Compat; import Compat.String
using JSON
using Blink
using Colors

# export some names from JSON
export json

# globals for this package
const _js_path = joinpath(dirname(dirname(@__FILE__)),
                          "deps", "plotly-latest.min.js")
const _js_cdn_path = "https://cdn.plot.ly/plotly-latest.min.js"

# include these here because they are used below
include("traces_layouts.jl")
abstract AbstractPlotlyDisplay

# core plot object
type Plot{TT<:AbstractTrace}
    data::Vector{TT}
    layout::AbstractLayout
    divid::Base.Random.UUID
end

# include the rest of the core parts of the package
include("json.jl")
include("display.jl")
include("subplots.jl")
include("api.jl")
include("savefig.jl")

# Set some defaults for constructing `Plot`s
Plot() = Plot(GenericTrace{Dict{Symbol,Any}}[], Layout(), Base.Random.uuid4())

Plot{T<:AbstractTrace}(data::Vector{T}, layout=Layout()) =
    Plot(data, layout, Base.Random.uuid4())

Plot(data::AbstractTrace, layout=Layout()) = Plot([data], layout)

# NOTE: we export trace constructing types from inside api.jl
# NOTE: we export names of shapes from traces_layouts.jl
export

    # core types
    Plot, GenericTrace, Layout, Shape, ElectronDisplay, JupyterDisplay,
    ElectronPlot, JupyterPlot, AbstractTrace, AbstractLayout,

    # other methods
    savefig, svg_data, png_data, jpeg_data, webp_data,

    # plotly.js api methods
    restyle!, relayout!, addtraces!, deletetraces!, movetraces!, redraw!,
    extendtraces!, prependtraces!,

    # non-!-versions (forks, then applies, then returns fork)
    restyle, relayout, addtraces, deletetraces, movetraces, redraw,
    extendtraces, prependtraces,

    # helper methods
    plot, fork, vline, hline, attr

end # module
