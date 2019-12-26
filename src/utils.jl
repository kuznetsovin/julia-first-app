"""
Сниппет для перевода dataframe в json

https://github.com/JuliaData/DataFrames.jl/issues/873
"""

using JSON, DataFrames, Query

function df2json(df::DataFrame)
  len = length(df[:, 1])
  indices = names(df)
  jsonarray = [Dict([string(index) => (isna(df[!, index][i]) ? nothing : df[!, index][i])
                                                    for index in indices])
                                                          for i in 1:len]
  return JSON.json(jsonarray)
end

function writejson(path::String, df::DataFrame)
  f = open(path,"w")
  write(f,df2json(df))
  close(f)
end