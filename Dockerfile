# Dockerfile (Ubicación: Raíz del repositorio)

# 1. Base Image
FROM python:3.11-slim

# Establecer la carpeta /app como directorio de trabajo
WORKDIR /app

# 2. Copiar archivos de dependencia y código fuente
# Copiar requirements.txt desde la raíz del repositorio local al WORKDIR /app
COPY requirements.txt .

# Copiar el código de la API desde src/api/ a /app/src/api/
# El código de la API es: main.py, inference.py, schemas.py
COPY src/api/ /app/src/api/

# Copiar los modelos y preprocesador (artefactos generados por el CI)
# Estos archivos se generaron en el step de entrenamiento y deben ser copiados:
COPY models/trained/house_price_model.pkl /app/models/trained/house_price_model.pkl
COPY models/trained/preprocessor.pkl /app/models/trained/preprocessor.pkl

# 3. Instalar dependencias
# Instalar los paquetes necesarios (FastAPI, joblib, scikit-learn, etc.)
RUN pip install --no-cache-dir -r requirements.txt

# 4. Exponer el puerto
EXPOSE 8000

# 5. Comando de lanzamiento
# uvicorn main:app --host 0.0.0.0 --port 8000
# El módulo de inicio debe ser relativo a dónde está el código (src.api.main)
CMD ["uvicorn", "src.api.main:app", "--host", "0.0.0.0", "--port", "8000"]