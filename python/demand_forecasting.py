import pandas as pd
from statsmodels.tsa.arima.model import ARIMA

sales = pd.read_csv("data/processed/Sales.csv")

sales['Sale_Date'] = pd.to_datetime(sales['Sale_Date'])

monthly_sales = sales.groupby(
    sales['Sale_Date'].dt.to_period('M')
)['Total_Amount'].sum()

monthly_sales.index = monthly_sales.index.to_timestamp()

# Fit ARIMA model
model = ARIMA(monthly_sales, order=(1,1,1))
model_fit = model.fit()

forecast = model_fit.forecast(steps=6)

print("Next 6 months forecast:")
print(forecast)
