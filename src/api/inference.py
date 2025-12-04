import joblib
import pandas as pd
from datetime import datetime
from pathlib import Path
from .schemas import HousePredictionRequest, PredictionResponse

# --- RUTAS ROBUSTAS A LOS PKL DENTRO DEL CONTENEDOR ---
# /app/src/api/inference.py → parents[2] = /app
BASE_DIR = Path(__file__).resolve().parents[2]
MODEL_DIR = BASE_DIR / "models" / "trained"

MODEL_PATH = MODEL_DIR / "house_price_model.pkl"
PREPROCESSOR_PATH = MODEL_DIR / "preprocessor.pkl"

try:
    model = joblib.load(MODEL_PATH)
    preprocessor = joblib.load(PREPROCESSOR_PATH)
except Exception as e:
    # Esto va a aparecer tal cual en los logs de kubectl
    raise RuntimeError(f"Error loading model or preprocessor from {MODEL_DIR}: {e}")

def predict_price(request: HousePredictionRequest) -> PredictionResponse:
    input_data = pd.DataFrame([request.dict()])
    input_data["house_age"] = datetime.now().year - input_data["year_built"]
    input_data["bed_bath_ratio"] = input_data["bedrooms"] / input_data["bathrooms"]
    input_data["price_per_sqft"] = 0  # Dummy value

    processed_features = preprocessor.transform(input_data)
    predicted_price = model.predict(processed_features)[0]

    predicted_price = round(float(predicted_price), 2)

    confidence_interval = [
        round(float(predicted_price * 0.9), 2),
        round(float(predicted_price * 1.1), 2),
    ]

    return PredictionResponse(
        predicted_price=predicted_price,
        confidence_interval=confidence_interval,
        features_importance={},
        prediction_time=datetime.now().isoformat(),
    )

def batch_predict(requests: list[HousePredictionRequest]) -> list[float]:
    input_data = pd.DataFrame([req.dict() for req in requests])
    input_data["house_age"] = datetime.now().year - input_data["year_built"]
    input_data["bed_bath_ratio"] = input_data["bedrooms"] / input_data["bathrooms"]
    input_data["price_per_sqft"] = 0  # Dummy value

    processed_features = preprocessor.transform(input_data)
    predictions = model.predict(processed_features)
    return predictions.tolist()
