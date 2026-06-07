# Raw Data

This folder contains the original GoExplore spreadsheet used as the starting point for the analysis.

The file represents the raw sales data before loading it into BigQuery and before creating the KPI dashboards.

## File

- `GoExplore.xlsx` — original GoExplore spreadsheet provided for the project covering sales data from 2015 to 2018
- `csv_tables/` — CSV versions of the spreadsheet tables prepared for BigQuery

## Usage

The Excel file represents the original source data.
The CSV files were used to create structured BigQuery tables for SQL analysis and dashboard development.
This raw spreadsheet was used as the source data for:
- Google Sheets review
- BigQuery table creation
- SQL-based KPI calculations
- Looker Studio dashboard development
- Final business presentation

## Note

The raw data is kept separate from the SQL queries, dashboards, and presentation files to make the project structure clear and easy to review.
