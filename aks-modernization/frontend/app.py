# frontend/app.py
import os
import requests
from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

# La URL del backend será inyectada como variable de entorno en Kubernetes.
# Para pruebas locales, apuntará al puerto del backend que expondremos.
backend_url = os.environ.get('BACKEND_API_URL', 'http://localhost:8000')

@app.route("/")
def index():
    try:
        # Obtiene los resultados actuales de la API de backend
        response = requests.get(f"{backend_url}/results")
        results = response.json()
    except requests.exceptions.ConnectionError:
        print(f"ERROR: No se pudo conectar a la API de backend en {backend_url}")
        results = {"dogs": "N/A", "cats": "N/A"}

    return render_template('index.html', results=results)

@app.route("/vote", methods=['POST'])
def vote():
    option = request.form['vote']
    try:
        # Envía el voto a la API de backend
        requests.post(f"{backend_url}/vote/{option}")
    except requests.exceptions.ConnectionError:
        print(f"ERROR: No se pudo conectar a la API de backend en {backend_url}")
    
    return redirect(url_for('index'))

if __name__ == '__main__':
    # Puerto 8080.
    app.run(host='0.0.0.0', port=8080, debug=True)
