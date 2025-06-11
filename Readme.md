# 📦 SQL Analytics Project – Contoso_100K  
**Author**: Abdurhman Hesham Al Wardany  
**Role**: Data Analyst | Portfolio Project  
**Tools Used**: SQL (Views, CTEs, Window Functions)  
**Dataset**: [Contoso_100K Sales Data](contoso_100k.sql)  

---

## 🧠 Project Overview

This SQL project simulates the type of data analysis a company would expect from an in-house analyst or BI team. Using the **Contoso_100K dataset**, the analysis explores multiple levels of business intelligence—starting with descriptive summaries and ending with strategic, executive-level insights.

All queries were written in raw SQL, without the use of BI tools or external scripting, to demonstrate pure query logic, optimization, and business acumen.

---

## 📂 Project Structure

The project is divided into **three difficulty levels**, each representing real-world business questions and the corresponding SQL techniques used to answer them.

### ✅ Easy Level – Descriptive Analytics  
**Goal**: Provide fundamental performance metrics  
- What are the total sales per month?  
- Which product categories generate the most revenue?  
- Who are the top 10 customers by total revenue?  
- What are the average, min, and max sales per region?

**Business Use**:  
📈 Monthly reporting, category targeting, customer ranking, and regional benchmarking.

---

### ⚙️ Medium Level – Diagnostic Analytics  
**Goal**: Dig deeper into patterns and performance  
- What are the top-selling products per region?  
- Who are the repeat customers with the highest average order value?  
- Which employees outperform the sales average?  
- What is the month-over-month growth in revenue?

**Business Use**:  
📌 Performance benchmarking, loyalty segmentation, regional strategy, revenue momentum tracking.

---

### 🔍 Hard Level – Strategic Analytics  
**Goal**: Extract business-critical insights  
- What are the top 3 products per customer by total spend?  
- What is each customer's Lifetime Value (LTV)?  
- Which regions are losing customers over time?

**Business Use**:  
🧠 Long-term forecasting, churn detection, customer-level personalization, profitability analysis.

---

### 📊 Executive-Level SQL View  
**View Created**: `monthly_exec_summary`  
- Total monthly sales  
- Count of new vs repeat customers  
- Top category per month by revenue

**Business Use**:  
📌 Designed for high-level dashboards used by C-level executives to monitor growth, retention, and performance.

---

## 💼 Why This Project Matters

This project demonstrates not only technical SQL skills, but also an understanding of **how to think like a business analyst**. The goal is not just to write queries—but to:
- Ask the right questions
- Design scalable analysis
- Connect data with decisions

---

## 📁 Repository Structure

```bash
📦 contoso-sql-analytics
├── 📁 sql
│   ├── 📁 Easy-level
│   ├── 📁 Medium-level
│   ├── 📁 Hard-level
│   └── 📁 Executive-Level SQL view
├── 📄 README.md
├── 📦 contoso_100k.sql
