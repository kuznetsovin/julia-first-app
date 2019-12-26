"""
Для установки LibPQ необходимо выполнить команды


import Pkg

Pkg.add("LibPQ")
Pkg.add("BinaryProvider")

include("/Users/kuznetsovin/.julia/packages/LibPQ/PeS3p/deps/build.jl")
"""

using DataFrames, LibPQ, Statistics

conn = LibPQ.Connection("dbname=track")

function getPgData()::DataFrame
    @info "Get data"
    df = @time DataFrame(execute(conn, "SELECT client,packet_id,navigate_date,received_date,nsat FROM vts.track"))

    @info "Aggregate data"
    result = @time by(df, :client, :packet_id => length, :navigate_date => minimum, :navigate_date => maximum, :nsat => mean)

    return result
    end;

