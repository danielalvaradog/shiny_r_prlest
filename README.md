# Student Onboarding Dashboard

A comprehensive Shiny dashboard for analyzing student onboarding data, built with R. This interactive dashboard provides insights into student registration, survey completion, geographic distribution, and learning preferences.

![Dashboard Preview](https://img.shields.io/badge/R-Shiny-blue)
![Status](https://img.shields.io/badge/status-active-success)

## Features

### Interactive Dashboard
- **Real-time Filtering**: Filter data by country, subscription type, onboarding status, acquisition channel, and date range
- **Key Metrics**: 
  - Total Students
  - Total Surveys Completed
  - Onboarding Rate (%)
  
### Visualizations
1. **World Map**: Global distribution showing onboarding rate by country with color-coded heatmap
2. **Acquisition Channels**: Bar chart showing where students heard about the platform
3. **Student Objectives**: Bar chart displaying student goals and aspirations
4. **Learning Interests**: Bar chart showing topics students want to learn

### Data Analysis
- 1,700+ student records
- Multiple data points per student (country, subscription type, goals, learning interests)
- Dynamic filtering and real-time updates

## Getting Started

### Prerequisites

- R (version 4.0 or higher)
- RStudio (recommended)

### Required R Packages

```r
install.packages(c(
  "shiny",
  "shinydashboard",
  "ggplot2",
  "dplyr",
  "tidyr",
  "lubridate",
  "scales",
  "maps",
  "viridis"
))
```

### Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/shiny_r.git
cd shiny_r
```

2. Open R or RStudio and set your working directory:
```r
setwd("path/to/shiny_r")
```

3. Run the dashboard:
```r
shiny::runApp()
```

Or in RStudio, simply open `app.R` and click "Run App".

## Project Structure

```
shiny_r_prlest/
├── app.R                          # Main Shiny application
├── R/
│   └── graphs.R                   # Visualization functions
├── data/
│   └── data_visualization.csv     # Student data
├── gitignore                      # Git ignore rules
└── README.md                      # This file
```

## Data Structure

The dashboard analyzes student data with the following fields:

- `user_id`: Unique student identifier
- `user_paid`: Payment status (1 = paid, 0 = free)
- `user_registered`: Registration date
- `onboarded`: Survey completion status
- `subscription_type`: Type of subscription (monthly, annual, quarterly)
- `completed_date`: Date when onboarding survey was completed
- `onboarding_country`: Student's country
- `onboarding_heard_from_label`: Acquisition channel
- `onboarding_goals_label`: Student's stated objectives
- `onboarding_learn_label`: Topics student wants to learn

## Using the Dashboard

### Filters

1. **Country**: Filter by specific country or view all
2. **Subscription Type**: Filter by subscription plan
3. **Onboarding Status**: View onboarded or not-onboarded students
4. **Acquisition Channel**: Filter by marketing channel
5. **Date Range**: Select registration date range
6. **Reset Filters**: Clear all filters with one click

### Interpreting the Visualizations

- **World Map**: Lighter colors indicate higher onboarding rates
- **Bar Charts**: All charts automatically update based on active filters
- **Metrics**: Value boxes show totals for the filtered dataset

## Author

Dani Alvarado

## Acknowledgments

- Built with [Shiny](https://shiny.rstudio.com/)
- Visualizations powered by [ggplot2](https://ggplot2.tidyverse.org/)
- Maps created with [maps](https://cran.r-project.org/package=maps) and [viridis](https://cran.r-project.org/package=viridis)

---

**Note**: This dashboard is designed for educational and analytical purposes. Ensure you have proper permissions to use and share any student data.
