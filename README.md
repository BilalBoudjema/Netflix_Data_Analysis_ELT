# 🎬 Netflix Data Analysis (With SQL Server)

This project presents a comprehensive cleaning and analysis of the **Netflix Movies and TV Shows dataset** using **SQL Server**. The dataset includes information such as titles, genres, directors, countries, cast members, durations, ratings, and more.

## 🗃️ Database Setup

- A custom collation (`Latin1_General_100_CI_AI_SC_UTF8`) is used to support foreign characters.
- The raw data is stored in a table named `netflix_table12`.
- Data is normalized and split into multiple tables for better analysis:
  - `netflix_directors_table`
  - `netflix_country_table`
  - `netflix_cast_table`
  - `netflix_genre_table`
  - Cleaned dataset: `netflix`

## 🧹 Data Cleaning & Preprocessing

- **Duplicate Detection**: Identified duplicates by `show_id` and (`title`, `type`).
- **Data Normalization**:
  - Split multi-valued columns (e.g., `director`, `country`, `cast`, `listed_in`) using `STRING_SPLIT()`.
- **Missing Value Handling**:
  - Inferred missing countries based on director-country relationships.
  - Replaced missing `duration` with `rating` as a fallback.
- **Final Cleaned Table**: Created a table `netflix` with one unique entry per (`title`, `type`), with clean and consistent data.

## 📊 Data Analysis Queries

### 1. Directors with Both Movies and TV Shows
- Counted how many **Movies** and **TV Shows** each director has made.
- Focused on directors who have produced **both formats**.

### 2. Country with Most Comedy Movies
- Identified the **country with the highest number** of comedy movies.

### 3. Most Active Movie Director by Year
- For each **year (based on `date_added`)**, found the director with the most **movie releases**.

### 4. Average Duration by Genre
- Computed the **average duration** (in minutes) of movies across different **genres**.

### 5. Directors of Both Comedy and Horror Movies
- Listed directors who directed **both horror and comedy movies** along with their respective counts.

## 📌 Technologies Used

- **SQL Server**
- SQL (DDL, DML, CTEs, Window Functions, Aggregations, Joins, Subqueries)

## 📁 Dataset Source

- The original dataset can be found on [Kaggle - Netflix Movies and TV Shows](https://www.kaggle.com/datasets/shivamb/netflix-shows)

## 📜 Author

**Bilal Boudjema **  
Master’s Graduate in Data & BI | Data Analyst | BI Developer  

## ✅ To Do

- Add visualizations using Power BI / Tableau.
- Automate cleaning and reporting process via stored procedures.
