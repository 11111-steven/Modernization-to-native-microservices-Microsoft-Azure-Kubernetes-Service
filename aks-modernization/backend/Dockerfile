# Build
FROM python:3.9-slim as builder

# Previene que Python escriba archivos .pyc y almacene en búfer la salida
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app
COPY requirements.txt .

# Crea un entorno virtual, activarlo y usarlo para instalar dependencias
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir -r requirements.txt

# Final
FROM python:3.9-slim

WORKDIR /app

# Copia el entorno virtual completo de la fase de construcción
COPY --from=builder /opt/venv /opt/venv

# Copia el código fuente de la aplicación
COPY . .

# Activa el entorno virtual para que el CMD pueda encontrar uvicorn
ENV PATH="/opt/venv/bin:$PATH"

EXPOSE 80
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "80"]
