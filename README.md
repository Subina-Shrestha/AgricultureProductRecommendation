# AgroRecSys – Agriculture Product Recommendation & Ordering System

AgroRecSys is a full-stack agriculture product recommendation and ordering platform that combines a traditional web application with a machine learning-based recommendation engine to deliver a smarter, more personalized shopping experience for agricultural products.

## Overview

The platform allows customers to browse and order agriculture products while receiving personalized recommendations powered by a hybrid machine learning model. Farmers can manage their product listings and orders, and admins can oversee the platform.

## Features

- **User Authentication** – Customer registration and login with client-side validation and password strength indicators
- **Product Catalog** – Browse products with quantity selection and detailed product pages
- **Personalized Recommendations** – ML-powered suggestions based on user behavior, refreshed on login, rating submission, and checkout
- **Checkout & Orders** – Full checkout flow with validation, order confirmation, and order history (Customer and Farmer views)
- **Email Notifications** – Automated order confirmation emails via Gmail SMTP
- **Role-Based Access** – Separate login flows for Customers, Farmers, and Admins
- **Homepage Highlights** – Dynamic display of top and recently added products

## Tech Stack

**Web Application**
- ASP.NET Web Forms (.NET Framework 4.8)
- C#
- SQL Server
- Bootstrap, HTML, CSS, JavaScript

**Recommendation Engine**
- Python, Flask
- scikit-learn, scikit-surprise
- Collaborative Filtering (SVD)
- Content-Based Filtering (TF-IDF)

## Recommendation Engine

The recommendation engine is a hybrid system trained on the Amazon Fine Food Reviews dataset and a Grocery dataset:

- **Collaborative Filtering** – SVD-based model (scikit-surprise) to predict user preferences from rating patterns
- **Content-Based Filtering** – TF-IDF vectorization to recommend products with similar attributes
- **ID Mapping Layer** – Bridges externally-trained model product IDs with the application's internal SQL Server product IDs

The engine is served via a Flask REST API with the following endpoints:

| Endpoint | Description |
|---|---|
| `/health` | Health check for the recommendation service |
| `/recommend/<id>` | Returns personalized recommendations for a given user |
| `/saved/<id>` | Returns saved/cached recommendations for a user |

## Architecture

```
ASP.NET Web Application  <-->  Flask Recommendation API
        |                              |
   SQL Server DB                Trained ML Models
                                 (SVD + TF-IDF)
```

The web application triggers calls to the ML service at key points — login, rating submission, and checkout — to keep recommendations up to date.

## Deployment

The application has been deployed locally via IIS, including:

- SQL Server permission configuration
- Static content and image handling
- Network configuration for access over a local network
- Externalized SMTP and database credentials (moved out of `Web.config` into dedicated configuration classes)

## Getting Started

1. Clone the repository
2. Open `AgricultureProductRecommendation.sln` in Visual Studio
3. Update the database connection string and SMTP credentials in the configuration files
4. Restore the SQL Server database
5. Run the Flask recommendation service separately (`localhost:5000`)
6. Build and run the solution via IIS Express or local IIS

## Author

**Subina Shrestha**
IT Engineering Student | Full-Stack & ML Project Experience
