module AnalyticsService

using HTTP, Sockets, Dates

include("postgres.jl")
include("utils.jl")

function getPoints(req::HTTP.Request)::HTTP.Response
    result = getPgData()

    @info "Marshall time"
    resp = @time df2json(result)

    return HTTP.Response(200, resp)
    end;

const ROUTER = HTTP.Router()
HTTP.@register(ROUTER, "GET", "/api", getPoints)

@info "Run server"
HTTP.serve(ROUTER, Sockets.localhost, 8081)

end # module
