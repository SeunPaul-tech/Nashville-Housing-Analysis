# Nashville Housing Market Analysis

<img width="965" height="546" alt="housing 1" src="https://github.com/user-attachments/assets/8f291017-8a95-4af1-bc53-e1cfea513390" />

## SQL Data Cleaning, Exploratory Data Analysis & Power BI Dashboard

---

# Executive Summary

Real estate datasets often contain duplicate records, inconsistent formatting, missing values, and data quality issues that can distort analysis and lead to poor business decisions.

In this project, I transformed the Nashville Housing dataset into a reliable analytical dataset using PostgreSQL. After performing extensive data cleaning and feature engineering, I explored key drivers of property values, housing market trends, and neighborhood performance.

The cleaned dataset was then used to build an interactive Power BI dashboard that allows users to explore Nashville's housing market through dynamic KPIs, filters, and visualizations. The project demonstrates an end-to-end analytics workflow—from raw data preparation to business intelligence reporting.

---

# Business Problem

The Nashville Housing dataset contains thousands of property transactions collected over multiple years. However, the raw dataset suffers from several common data quality issues:

- Duplicate property records
- Inconsistent data formats
- Missing addresses and valuation fields
- Mixed categorical values
- Text-formatted dates and currency values

Without addressing these issues, meaningful analysis of Nashville's housing market would be unreliable.

The goal of this project was to clean and standardize the data before answering important business questions such as:

- What factors influence housing prices?
- Which property types generate the most revenue?
- Which neighborhoods are most valuable?
- How has the housing market evolved over time?
- What characteristics define high-value properties?

---

# Project Objectives

The objectives of this project were to:

- Clean and prepare the housing dataset for analysis.
- Remove duplicate transactions.
- Standardize inconsistent values.
- Handle missing values appropriately.
- Engineer new variables to improve analysis.
- Explore pricing trends and market performance.
- Identify relationships between property characteristics and sale prices.
- Build an interactive Power BI dashboard for business users.

---

# Dataset Overview

The dataset contains residential property transactions within Nashville, Tennessee.

It includes information such as:

- Parcel ID
- Property Address
- Sale Date
- Sale Price
- Land Use
- Land Value
- Building Value
- Total Property Value
- Acreage
- Bedrooms
- Bathrooms
- Tax District
- Year Built
- Vacant Sale Status

Although the dataset contained rich information about Nashville's housing market, it required significant preprocessing before it could support reliable business analysis.

---

# Tools Used

- PostgreSQL
- Power BI
- DAX
- Power Query
- Figma

---

# Data Cleaning & Preparation

A significant portion of this project focused on improving data quality before analysis.

## 1. Duplicate Removal

Using the `ROW_NUMBER()` window function, duplicate property records were identified based on:

- Land Use
- Property Address
- Sale Price
- Sold As Vacant

Duplicate rows were removed while preserving a single valid transaction for each property.

---

## 2. Data Type Conversion

Several columns required conversion into appropriate data types.

### Sale Date

Converted from **TEXT** to **DATE**.

### Sale Price

- Removed currency symbols (`$`)
- Removed commas
- Converted from **TEXT** to **NUMERIC**

This ensured accurate numerical calculations throughout the analysis.

---

## 3. Data Standardization

Several inconsistencies were corrected throughout the dataset.

These included:

- Converting Land Use values into proper title case.
- Standardizing Sold As Vacant values from **Y/N** to **Yes/No**.
- Separating Property Address into:
  - Property Address
  - Property City
- Separating Owner Address into:
  - Owner Address
  - Owner City
  - Owner State

These transformations improved consistency and made the dataset easier to analyze.

---

## 4. Missing Value Handling

Different strategies were used depending on the column.

### Property Address

Missing addresses were populated using matching Parcel IDs.

### Numerical Columns

Missing values in:

- Acreage
- Land Value
- Building Value

were imputed using their respective column averages.

### Total Property Value

Rather than imputing missing values directly, the column was recreated by summing:

- Land Value
- Building Value

This ensured greater accuracy.

---

## 5. Feature Engineering

Additional columns were created to improve reporting and visualization.

These included:

- Property Address
- Property City
- Owner Address
- Owner City
- Owner State
- Recalculated Total Property Value

These new fields enhanced both SQL analysis and Power BI reporting.

---

# Exploratory Data Analysis (EDA)

After cleaning the dataset, the following business questions were explored:

1. Which factors have the strongest relationship with property sale prices?
2. How has Nashville's housing market changed over time?
3. What is the total market value by year?
4. Which property types generate the highest revenue?
5. Which locations have the most valuable housing markets?
6. Which tax districts have the highest average sale prices?
7. What percentage of properties were sold as vacant?
8. How do vacant property prices compare with occupied properties?
9. What is the bedroom distribution across Nashville properties?
10. Does acreage influence sale price?
11. What is the relationship between property age and sale price?

---

# Key KPIs

The Power BI dashboard summarizes Nashville's housing market using KPIs including:

- Total Sales
- Average Sale Price
- Total Properties Sold
- Owner Occupancy Rate
- Vacant Property Rate
- Average Sale Price per Acre
- Average Property Value
- Average Building Value
- Average Land Value

Additional analytical measures include:

- Year-over-Year Sales Growth
- Rolling Average Sale Price
- Average Sale Price by Property Type
- Average Sale Price by Tax District

---

# Analysis & Insights

## Property Value Is the Strongest Predictor of Sale Price

Correlation analysis revealed that:

- Total Property Value
- Building Value
- Land Value

have the strongest positive relationship with property sale prices.

This indicates that assessed property values are reliable indicators of market prices.

---

## Nashville's Housing Market Has Changed Over Time

Analyzing historical sales showed fluctuations in:

- Average Sale Price
- Total Market Value

These trends provide insight into how Nashville's real estate market has evolved over the years.

---

## Single-Family Homes Generate the Highest Revenue

Among all property types, **Single Family** properties generated the largest share of total sales revenue, making them the dominant segment of Nashville's housing market.

---

## High-Value Neighborhoods Stand Out

Property values vary significantly across different locations.

The analysis identified **2800 McGavock Pike** as one of the most valuable property locations, with approximately **$13.3 million** in total property value.

---

## Belle Meade Records the Highest Average Sale Price

Among all tax districts, **City of Belle Meade** recorded the highest average property sale price, highlighting its premium real estate market.

---

## Vacant Property Sales Represent a Small Share of the Market

Only **7.8%** of properties were sold as vacant.

Interestingly, the average sale price of vacant properties was relatively close to that of occupied properties, suggesting vacancy status alone does not significantly impact pricing.

---

## Three-Bedroom Homes Dominate Nashville's Housing Inventory

Three-bedroom homes account for more than half of all residential properties, making them the most common housing type within the dataset.

---

## Acreage Has Little Influence on Sale Price

Correlation analysis showed only a **very weak positive relationship** between acreage and sale price.

This suggests that property size alone does not strongly determine market value.

---

## Property Age Is Not the Primary Driver of Price

Grouping homes by construction period revealed that newer homes do not consistently command the highest prices.

Factors such as:

- Location
- Building Value
- Land Value

appear to play a much larger role in determining sale prices.

---

# Business Recommendations

Based on the analysis, the following recommendations are suggested:

- Prioritize building and land values when developing property valuation models.
- Focus investment opportunities within premium neighborhoods such as Belle Meade.
- Continue monitoring the single-family housing segment, as it represents the largest source of market revenue.
- Incorporate external variables such as school quality, crime rates, and neighborhood amenities to better explain pricing differences.
- Maintain strong data quality practices by validating addresses, removing duplicates, and standardizing categorical values before conducting analysis.

---

# Dashboard

An interactive Power BI dashboard was developed to allow users to:

- Filter housing data by year, property type, and occupancy status.
- Monitor housing market trends over time.
- Compare neighborhood performance.
- Analyze vacant versus occupied property sales.
- Explore housing characteristics through interactive visuals.
- Track key performance indicators using dynamic slicers and drill-through functionality.

---

# Conclusion

This project demonstrates a complete end-to-end data analytics workflow.

Starting with a raw housing dataset containing duplicates, inconsistencies, and missing values, the data was cleaned, standardized, and transformed into a reliable analytical dataset using PostgreSQL.

The cleaned data was then analyzed to uncover trends, identify key drivers of property values, and answer meaningful business questions. Finally, the insights were presented through an interactive Power BI dashboard designed to support data-driven decision-making.

Beyond SQL, this project showcases the importance of data quality, feature engineering, business-focused analysis, and effective storytelling—illustrating how analytics creates value by turning raw data into actionable insights.
```

<img width="968" height="542" alt="Housing 3" src="https://github.com/user-attachments/assets/744302d6-05cd-47b3-9a59-680a71d1542b" />


