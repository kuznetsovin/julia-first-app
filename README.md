# Julia first app

Simple web application which gets data from PostgreSQL database, aggregate it and return json with data.

For speed test append python web service (python+aiohttp)

|           Name                        | Julia(s)  | Python (s) |
|---------------------------------------|-----------|------------|
|Suumary request time                   | 189.918   | 17.238     |
|Get and transform data to df           | 165.57840 | 17.047672  |
|Aggregation time                       | 15.187950 | 0.151542   |
|Time json marshalling                  | 2.421602  | 0.0024690  |

My article by [Russian](https://www.swe-notes.ru/post/julia-web-app/)
