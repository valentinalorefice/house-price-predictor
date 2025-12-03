# Dockerfile (Ubicación: streamlit_app/)
FROM python:3.9-slim

WORKDIR /app

# Copiar archivos de dependencia y código
COPY requirements.txt .
COPY app.py .

# Instalar dependencias
RUN pip install -r requirements.txt

# Exponer el puerto
EXPOSE 8501

# Comando de lanzamiento para Streamlit
CMD ["streamlit", "run", "app.py", "--server.address=0.0.0.0"]