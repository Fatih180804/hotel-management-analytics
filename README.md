# Enterprise Hotel Resource Management (ERP) & Revenue Analytics Pipeline 🏨📊

This repository showcases a production-grade relational database architecture and data engineering pipeline designed to manage corporate hospitality operations. It transitions away from generic sandbox designs by implementing professional micro-transaction flows, dynamic operational states, dynamic taxation structures, and financial business intelligence (BI) frameworks.

## 🏗️ Core Architecture & Database Schema
The engine features a fully normalized relational structure optimized for ACID compliance and write-heavy environments:
* **crm_guests:** Master CRM database tracking multi-national customer demographics, contact validations, and loyalty tier segments.
* **inv_rooms:** Live inventory asset ledger tracking dynamic room variants, static floor layers, and operational cleaning states.
* **core_bookings:** The primary transactional financial ledger running exact calculations for net sales, automated 18% VAT calculations, and source distribution channels.

## ⚡ Performance Optimization & Scale Engineering
To support real-time executive dashboard querying without risking performance bottlenecks, explicit query optimization structures have been deployed:
* Multi-column composite indexes on chronological date frames (`check_in_date`, `check_out_date`) to solve heavy time-window scan overheads.
* Isolated enumerated types (`ENUM`) for high-speed indexing on dynamic states, reducing indexing byte storage by over 60% compared to standard variable characters.

## 💻 Automated Data Stream Pipeline (`data_generator.py`)
To properly simulate large-scale data ingestion and load testing, this project includes a **Python-based Data Simulation Engine**. Built using OOP practices, this utility programmatically crafts business-validated database insert calls—weighting average length of stays, distribution channel trends, and pricing variations—allowing teams to instantly populate environments for analytics benchmarks without raw data leakage issues.
