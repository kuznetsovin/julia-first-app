import sys
import time

import numpy as np
import pandas
import psycopg2
from aiohttp import web
from psycopg2.extras import RealDictCursor

estp_con = psycopg2.connect('postgresql://localhost/track')
cr = estp_con.cursor(cursor_factory=RealDictCursor)


async def handle(request):
    s = time.time()
    cr.execute("SELECT client,packet_id,navigate_date,received_date,nsat FROM vts.track")
    df = pandas.DataFrame(cr.fetchall(), columns=["client", "packet_id", "navigate_date", "received_date", "nsat"])
    e = time.time()

    print("Received data. Time: {}. Mem: {}".format(e - s, sys.getsizeof(df)))

    s = time.time()
    result = df.pivot_table(df,
                            index=['client'],
                            aggfunc={'packet_id': len,
                                     'navigate_date': [min, max],
                                     'nsat': np.mean,
                                     })
    result.columns = list(map("_".join, result.columns))
    result.reset_index(inplace=True)
    e = time.time()
    print("Agg data. Time: {}. Mem: {}".format(e - s, sys.getsizeof(result)))

    s = time.time()
    resp = result.to_json(orient='records')
    e = time.time()
    print("Marshal data. Time: {}. Mem: {}".format(e - s, sys.getsizeof(resp)))

    return web.Response(text=resp)


app = web.Application()
app.add_routes([web.get('/api', handle)])

if __name__ == '__main__':
    web.run_app(app)
