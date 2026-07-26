
☕ Monday Coffee Expansion Analysis Project (SQL)
An end-to-end SQL analysis project to identify the best cities in India for a coffee company to open new stores, based on consumer demand, sales performance, and cost efficiency.


![Company Logo](https://github.com/najirh/Monday-Coffee-Expansion-Project-P8/blob/main/1.png)

📁 Project Structure
Monday-Coffee-Expansion-Analysis-Project-using-sql/
│
├── monday_coffee_analysis_project.sql   # All SQL analysis queries
├── city.csv                             # City-level population & rent data
├── customers.csv                        # Customer records by city
├── products (1).csv                      # Product catalog
├── sales.csv                             # Transaction-level sales data
├── 1.png - 6.png                         # Output charts/screenshots
└── README.md

🛠️ Tools Used
Tool          Purpose
SQL           All data analysis and business queries
CSV datasets  Source data (city, customer, product, sales)

📊 Dataset
Monday Coffee has been selling online since January 2023.
Tables used: city, customers, products, sales
Key fields: city name, population, estimated rent, customer id, product id, sale date, total sale amount

🎯 Objective
Analyze sales data to recommend the top 3 cities in India for opening new coffee shop locations, based on consumer demand and sales performance.

🗄️ Key Business Questions Answered
Query   Business Question
1       How many people in each city are estimated coffee consumers (25% of population)?
2       What is the total revenue from coffee sales across all cities in Q4 2023?
3       How many units of each product have been sold?
4       What is the average sales amount per customer in each city?
5       What is each city's population vs. estimated coffee consumers?
6       What are the top 3 selling products in each city by volume?
7       How many unique customers exist per city?
8       What is the average sale vs. average rent per customer, per city?
9       What is the month-over-month sales growth rate?
10      Which top 3 cities have the highest market potential (sales, rent, customers, consumers)?

⚙️ How to Run
1. Clone the repo
   git clone https://github.com/aravindracharla9391/Monday-Coffee-Expansion-Analysis-Project-using-sql.git
   cd Monday-Coffee-Expansion-Analysis-Project-using-sql

2. Import the CSVs (city.csv, customers.csv, products (1).csv, sales.csv) into your SQL database (MySQL/PostgreSQL).

3. Run the analysis
   Open monday_coffee_analysis_project.sql in your SQL client and execute the queries against the imported tables.

🔑 Recommendations
Based on the analysis, the top 3 cities recommended for new store openings are:

**1. Pune** — Very low average rent per customer, highest total revenue, high average sales per customer.

**2. Delhi** — Highest estimated coffee consumers (7.7M), highest number of customers (68), rent still under 500/customer.

**3. Jaipur** — Highest number of customers (69), lowest average rent per customer (156), strong average sales per customer (11.6k).

⚠️ Known Limitations
- Analysis based on estimated (not measured) coffee consumption at 25% of city population
- Revenue figures limited to available quarters in the dataset
- Rent figures are city-level averages, not per-store estimates

👤 Author
Aravind Racharla
GitHub | LinkedIn: in/aravind-racharla
# ☕ Monday Coffee Expansion Analysis Project (SQL)

An end-to-end SQL analysis project to identify the best cities in India for a coffee company to open new stores, based on consumer demand, sales performance, and cost efficiency.

![Monday Coffee Logo](1.png)

---

## 📁 Project Structure
