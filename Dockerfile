# Dockerfile (Ubicación: Raíz del repositorio)

# 1. Base Image
FROM python:3.11-slim

# 2. Directorio de trabajo
WORKDIR /app

# 3. Dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 4. Código de la API
COPY src/api/ /app/src/api/

# 5. Artefactos del modelo (.pkl)
#   - /app/models/trained           → por si tu código los busca ahí
#   - /app/src/api/models/trained   → por si los busca relativo al paquete api
RUN mkdir -p /app/models/trained /app/src/api/models/trained
COPY models/trained/ /app/models/trained/
COPY models/trained/ /app/src/api/models/trained/

# 6. Puerto
EXPOSE 8000

# 7. Comando de arranque
CMD ["uvicorn", "src.api.main:app", "--host", "0.0.0.0", "--port", "8000"]
