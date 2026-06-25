"""
ML-1: Demand Forecast Prototype for EPSA Compras
=================================================
Generates 3-month demand forecasts per article using exponential smoothing
with trend and seasonality decomposition.

Data Source: staging_compras.dbo.stg_factConsumo (1.7M+ records, 5 years)
Output: Console report + CSV export for validation

Usage: python scripts/ml/demand_forecast.py
"""

import pandas as pd
import numpy as np
from datetime import datetime, timedelta
from pathlib import Path
import warnings
warnings.filterwarnings('ignore')

# === Configuration ===
DATA_DIR = Path(__file__).parent.parent.parent / "docs" / "ml_output"
CSV_FILE = DATA_DIR / "consumo_historia_ml.csv"

FORECAST_MONTHS = 3
MIN_HISTORY_MONTHS = 12  # minimum months of data for reliable forecast
TOP_N_ARTICLES = 50       # forecast top N articles by consumption volume
ALPHA = 0.3               # exponential smoothing factor (level)
BETA = 0.1                # trend smoothing factor
OUTPUT_DIR = Path(__file__).parent.parent.parent / "docs" / "ml_output"

def load_consumption_data():
    """Load consumption data from exported CSV"""
    print(f"      Reading from: {CSV_FILE}")
    df = pd.read_csv(CSV_FILE, parse_dates=['Fecha'], decimal=',')
    
    # Aggregate to monthly
    df['YearMonth'] = df['Fecha'].dt.to_period('M')
    monthly = df.groupby(['ArticuloCodigo', 'YearMonth'])['Cantidad'].sum().reset_index()
    monthly['YearMonth'] = monthly['YearMonth'].dt.to_timestamp()
    
    return monthly

def exponential_smoothing_forecast(series, alpha=ALPHA, beta=BETA, forecast_steps=FORECAST_MONTHS):
    """
    Double exponential smoothing (Holt's method) for trend + level.
    Returns forecast values and confidence bounds.
    """
    if len(series) < 3:
        return np.full(forecast_steps, series.mean() if len(series) > 0 else 0), \
               np.full(forecast_steps, 0), np.full(forecast_steps, series.mean() * 2 if len(series) > 0 else 0)
    
    values = series.values.astype(float)
    
    # Initialize
    level = values[0]
    trend = (values[-1] - values[0]) / (len(values) - 1) if len(values) > 1 else 0
    
    # Smooth
    levels = [level]
    trends = [trend]
    
    for i in range(1, len(values)):
        new_level = alpha * values[i] + (1 - alpha) * (levels[-1] + trends[-1])
        new_trend = beta * (new_level - levels[-1]) + (1 - beta) * trends[-1]
        levels.append(new_level)
        trends.append(new_trend)
    
    # Forecast
    forecasts = []
    for h in range(1, forecast_steps + 1):
        f = levels[-1] + h * trends[-1]
        forecasts.append(max(0, f))  # demand can't be negative
    
    # Confidence bounds (simple: +/- 1.96 * residual std)
    fitted = np.array([levels[i-1] + trends[i-1] for i in range(1, len(values))])
    residuals = values[1:] - fitted
    residual_std = np.std(residuals) if len(residuals) > 2 else np.std(values) * 0.3
    
    lower = [max(0, f - 1.96 * residual_std) for f in forecasts]
    upper = [f + 1.96 * residual_std for f in forecasts]
    
    return np.array(forecasts), np.array(lower), np.array(upper)

def detect_seasonality(series, period=12):
    """Simple seasonality detection using autocorrelation"""
    if len(series) < 2 * period:
        return 1.0, "None"
    
    # Deseasonalize with moving average
    ma = series.rolling(window=period, center=True).mean()
    seasonal_ratio = series / ma
    
    # Average seasonal factors
    seasonal_factors = []
    for m in range(period):
        month_factors = seasonal_ratio.iloc[m::period].dropna()
        seasonal_factors.append(month_factors.mean() if len(month_factors) > 0 else 1.0)
    
    # Normalize
    seasonal_factors = np.array(seasonal_factors)
    seasonal_factors = seasonal_factors / seasonal_factors.mean()
    
    # Strength: variance of seasonal factors
    strength = 1 - np.var(series.dropna() - series.dropna().rolling(period).mean().dropna()) / np.var(series.dropna()) if np.var(series.dropna()) > 0 else 0
    
    return seasonal_factors, "Strong" if strength > 0.5 else "Moderate" if strength > 0.2 else "Weak"

def forecast_articles(monthly_df, top_n=TOP_N_ARTICLES):
    """Generate forecasts for top N articles"""
    # Select top articles by total volume
    article_totals = monthly_df.groupby('ArticuloCodigo')['Cantidad'].sum().nlargest(top_n)
    top_articles = article_totals.index.tolist()
    
    results = []
    current_date = monthly_df['YearMonth'].max()
    
    for article in top_articles:
        article_data = monthly_df[monthly_df['ArticuloCodigo'] == article].copy()
        article_data = article_data.sort_values('YearMonth')
        
        if len(article_data) < MIN_HISTORY_MONTHS:
            continue
        
        series = article_data.set_index('YearMonth')['Cantidad']
        
        # Fill missing months with 0
        full_range = pd.date_range(start=series.index.min(), end=series.index.max(), freq='MS')
        series = series.reindex(full_range, fill_value=0)
        
        # Detect seasonality
        seasonal_factors, season_strength = detect_seasonality(series)
        
        # Apply seasonal adjustment if strong seasonality detected
        if season_strength == "Strong" and isinstance(seasonal_factors, np.ndarray):
            deseasonalized = series.copy()
            for i, (idx, val) in enumerate(series.items()):
                month_idx = idx.month - 1
                deseasonalized.iloc[i] = val / seasonal_factors[month_idx] if seasonal_factors[month_idx] > 0 else val
            forecast_input = deseasonalized
        else:
            forecast_input = series
        
        # Generate forecast
        forecast, lower, upper = exponential_smoothing_forecast(forecast_input)
        
        # Re-apply seasonality
        if season_strength == "Strong" and isinstance(seasonal_factors, np.ndarray):
            forecast_months = [(current_date + timedelta(days=30*(h+1))).month - 1 for h in range(FORECAST_MONTHS)]
            for h in range(FORECAST_MONTHS):
                forecast[h] *= seasonal_factors[forecast_months[h]]
                lower[h] *= seasonal_factors[forecast_months[h]]
                upper[h] *= seasonal_factors[forecast_months[h]]
        
        # Calculate metrics
        avg_monthly = series.mean()
        cv = series.std() / series.mean() if series.mean() > 0 else 0
        trend_direction = "↑" if forecast[0] > avg_monthly * 1.1 else "↓" if forecast[0] < avg_monthly * 0.9 else "→"
        
        results.append({
            'Articulo': article,
            'Historia_Meses': len(series),
            'Consumo_Mensual_Prom': round(avg_monthly, 1),
            'CV': round(cv, 2),
            'Estacionalidad': season_strength,
            'Tendencia': trend_direction,
            'Forecast_M1': round(forecast[0], 1),
            'Forecast_M2': round(forecast[1], 1),
            'Forecast_M3': round(forecast[2], 1),
            'Lower_M1': round(lower[0], 1),
            'Upper_M1': round(upper[0], 1),
            'Lower_M3': round(lower[2], 1),
            'Upper_M3': round(upper[2], 1),
        })
    
    return pd.DataFrame(results)

def main():
    print("=" * 70)
    print("  EPSA Compras - ML-1: Pronóstico de Demanda")
    print(f"  Fecha: {datetime.now().strftime('%Y-%m-%d %H:%M')}")
    print("=" * 70)
    
    # Load data
    print("[1/4] Cargando historial de consumos...")
    monthly = load_consumption_data()
    print(f"      {len(monthly):,} registros mensuales")
    print(f"      {monthly['ArticuloCodigo'].nunique():,} artículos")
    print(f"      Rango: {monthly['YearMonth'].min().strftime('%Y-%m')} a {monthly['YearMonth'].max().strftime('%Y-%m')}")
    
    # Forecast
    print(f"[2/4] Generando pronósticos (top {TOP_N_ARTICLES} artículos)...")
    forecast_df = forecast_articles(monthly, TOP_N_ARTICLES)
    print(f"      {len(forecast_df)} pronósticos generados")
    
    # Report
    print(f"\n[3/4] Resultados:")
    print("-" * 70)
    print(f"{'Artículo':<18} {'Prom.Mens':>10} {'CV':>5} {'Tend':>4} {'F_M1':>10} {'F_M2':>10} {'F_M3':>10}")
    print("-" * 70)
    
    for _, row in forecast_df.head(20).iterrows():
        print(f"{row['Articulo']:<18} {row['Consumo_Mensual_Prom']:>10.1f} {row['CV']:>5.2f} "
              f"{row['Tendencia']:>4} {row['Forecast_M1']:>10.1f} {row['Forecast_M2']:>10.1f} {row['Forecast_M3']:>10.1f}")
    
    # Summary stats
    print("-" * 70)
    print(f"\nResumen:")
    print(f"  Artículos con tendencia ascendente: {len(forecast_df[forecast_df['Tendencia'] == '↑'])}")
    print(f"  Artículos con tendencia descendente: {len(forecast_df[forecast_df['Tendencia'] == '↓'])}")
    print(f"  Artículos estables: {len(forecast_df[forecast_df['Tendencia'] == '→'])}")
    print(f"  Alta variabilidad (CV > 1.0): {len(forecast_df[forecast_df['CV'] > 1.0])}")
    print(f"  Estacionalidad fuerte: {len(forecast_df[forecast_df['Estacionalidad'] == 'Strong'])}")
    
    # Export
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    output_file = OUTPUT_DIR / "demand_forecast_results.csv"
    forecast_df.to_csv(output_file, index=False)
    print(f"\n  Exportado a: {output_file}")
    
    print("\n✓ Pronóstico completado.")

if __name__ == "__main__":
    main()
