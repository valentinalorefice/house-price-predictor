# ---------------------------------------------
# DOCKERFILE — FASTAPI MODEL SERVICE
# ---------------------------------------------

FROM python:3.9

WORKDIR /app

# -------- INSTALL DEPENDENCIES ----------
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# -------- COPY API CODE ----------
COPY src/api/ /app/src/api/

# -------- COPY MODEL ARTEFACTS ----------
RUN mkdir -p /app/models/trained /app/src/api/models/trained
COPY models/trained/ /app/models/trained/
COPY models/trained/ /app/src/api/models/trained/

EXPOSE 8000

CMD ["uvicorn", "src.api.main:app", "--host", "0.0.0.0", "--port", "8000"]
