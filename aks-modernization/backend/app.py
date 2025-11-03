# backend/app.py
import os
from fastapi import FastAPI
from redis import Redis

app = FastAPI()

# Conexión a Redis. El nombre 'redis-service' será el que usemos en Kubernetes.
# Para pruebas locales, usaremos 'localhost' por defecto.
redis_host = os.environ.get('REDIS_HOST', 'localhost')
redis_conn = Redis(host=redis_host, port=6379, db=0, decode_responses=True)

@app.get("/")
def read_root():
    return {"message": "Backend API is running"}

@app.post("/vote/{option}")
def cast_vote(option: str):
    # Incrementa el contador para la opción votada ('dogs' o 'cats')
    count = redis_conn.incr(option)
    return {"option": option, "count": count}

@app.get("/results")
def get_results():
    dogs_count = redis_conn.get('dogs') or 0
    cats_count = redis_conn.get('cats') or 0
    return {"dogs": dogs_count, "cats": cats_count}
