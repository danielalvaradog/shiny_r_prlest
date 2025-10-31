# Graph and Plotting Functions
# This file contains all visualization functions used in the Shiny dashboard

library(ggplot2)
library(dplyr)
library(tidyr)
library(scales)
library(lubridate)
library(maps)
library(viridis)

# Custom color palette
custom_colors <- c("#3498db", "#e74c3c", "#2ecc71", "#f39c12", "#9b59b6", 
                   "#1abc9c", "#34495e", "#e67e22", "#95a5a6", "#16a085")

#' Create acquisition channel plot
#' 
#' @param data A data frame containing onboarding_heard_from_label column
#' @return A ggplot object
plot_acquisition_channels <- function(data) {
  channel_data <- data %>%
    filter(!is.na(onboarding_heard_from_label), 
           onboarding_heard_from_label != "NULL",
           onboarding_heard_from_label != "") %>%
    group_by(onboarding_heard_from_label) %>%
    summarise(count = n(), .groups = "drop") %>%
    arrange(desc(count)) %>%
    mutate(percentage = count / sum(count) * 100)
  
  ggplot(channel_data, aes(x = reorder(onboarding_heard_from_label, count), 
                            y = count, fill = onboarding_heard_from_label)) +
    geom_bar(stat = "identity", alpha = 0.8) +
    scale_fill_manual(values = custom_colors) +
    coord_flip() +
    theme_minimal() +
    labs(
      title = "User Acquisition Channels",
      x = "Channel",
      y = "Number of Users"
    ) +
    theme(
      plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
      legend.position = "none",
      panel.grid.major.y = element_blank()
    )
}

#' Create user goals plot
#' 
#' @param data A data frame containing onboarding_goals_label column
#' @return A ggplot object
plot_user_goals <- function(data) {
  goals_data <- data %>%
    filter(!is.na(onboarding_goals_label),
           onboarding_goals_label != "NULL",
           onboarding_goals_label != "") %>%
    group_by(onboarding_goals_label) %>%
    summarise(count = n(), .groups = "drop") %>%
    arrange(desc(count))
  
  ggplot(goals_data, aes(x = reorder(onboarding_goals_label, count), 
                          y = count, fill = onboarding_goals_label)) +
    geom_bar(stat = "identity", alpha = 0.8) +
    scale_fill_manual(values = custom_colors) +
    coord_flip() +
    theme_minimal() +
    labs(
      title = "User Goals Distribution",
      x = "Goal",
      y = "Number of Users"
    ) +
    theme(
      plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
      axis.text.y = element_text(size = 9),
      legend.position = "none",
      panel.grid.major.y = element_blank()
    )
}

#' Create learning interests plot
#' 
#' @param data A data frame containing onboarding_learn_label column
#' @return A ggplot object
plot_learning_interests <- function(data) {
  learning_data <- data %>%
    filter(!is.na(onboarding_learn_label),
           onboarding_learn_label != "NULL",
           onboarding_learn_label != "") %>%
    group_by(onboarding_learn_label) %>%
    summarise(count = n(), .groups = "drop") %>%
    arrange(desc(count))
  
  ggplot(learning_data, aes(x = reorder(onboarding_learn_label, count), 
                             y = count, fill = onboarding_learn_label)) +
    geom_bar(stat = "identity", alpha = 0.8) +
    scale_fill_manual(values = custom_colors) +
    coord_flip() +
    theme_minimal() +
    labs(
      title = "Learning Interests",
      x = "Topic",
      y = "Number of Users"
    ) +
    theme(
      plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
      axis.text.y = element_text(size = 9),
      legend.position = "none",
      panel.grid.major.y = element_blank()
    )
}

#' Create world map with onboarding rate by country
#' 
#' @param data A data frame containing onboarding_country and onboarded columns
#' @return A ggplot object
plot_world_map_rate <- function(data) {
  # Get world map data
  world_map <- map_data("world")
  
  # Calculate onboarding rate by country
  country_rates <- data %>%
    filter(!is.na(onboarding_country),
           onboarding_country != "NULL",
           onboarding_country != "") %>%
    group_by(onboarding_country) %>%
    summarise(
      total = n(),
      onboarded = sum(onboarded == "onboarded", na.rm = TRUE),
      rate = if_else(total > 0, (onboarded / total) * 100, 0),
      .groups = "drop"
    )
  
  # Create a mapping for country name variations
  country_mapping <- c(
    "United States of America" = "USA",
    "United Kingdom" = "UK",
    "Eswatini (fmr. Swaziland\")" = "Swaziland",
    "Eswatini (fmr. Swaziland" = "Swaziland"
  )
  
  # Apply country name mapping
  country_rates <- country_rates %>%
    mutate(region = ifelse(onboarding_country %in% names(country_mapping),
                           country_mapping[onboarding_country],
                           onboarding_country))
  
  # Merge with world map data
  world_data <- world_map %>%
    left_join(country_rates, by = "region")
  
  # Create the map
  ggplot(world_data, aes(x = long, y = lat, group = group)) +
    geom_polygon(aes(fill = rate), color = "white", linewidth = 0.1) +
    scale_fill_viridis(
      option = "viridis",
      na.value = "grey90",
      name = "Onboarding\nRate (%)",
      limits = c(0, 100),
      breaks = c(0, 25, 50, 75, 100)
    ) +
    coord_fixed(1.3) +
    theme_minimal() +
    labs(
      title = "Global Onboarding Rate by Country",
      x = NULL,
      y = NULL
    ) +
    theme(
      plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
      axis.text = element_blank(),
      axis.ticks = element_blank(),
      panel.grid = element_blank(),
      legend.position = "right"
    )
}
