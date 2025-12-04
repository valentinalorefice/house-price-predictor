FROM python:3.9

WORKDIR /app

# 1. Copiar dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 2. Copiar código API
COPY src/api/ /app/src/api/

# 3. Crear carpetas para los modelos
RUN mkdir -p /app/models/trained /app/src/api/models/trained

# 4. Copiar artefactos del modelo
COPY models/trained/ /app/models/trained/
COPY models/trained/ /app/src/api/models/trained/

# 5. Exponer puerto
EXPOSE 8000

# 6. Correr FastAPI
CMD ["uvicorn", "src.api.main:app", "--host", "0.0.0.0", "--port", "8000"]
