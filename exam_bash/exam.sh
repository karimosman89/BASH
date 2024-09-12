#!/bin/bash

# Create a function to retrieve the sales figures for a given graphics card
function get_sales_figures() {
  # Get the sales data from the API
  sales_data=$(curl http://localhost:5000/sales)

  # Parse the JSON data
  parsed_sales_data=$(python -m json.tool <<< $sales_data)

  # Extract the sales for the given graphics card
  sales=$(echo "$parsed_sales_data" | grep "$1" | cut -d ':' -f 2)

  # Return the sales
  echo "$sales"
}

# Create a list of graphics cards
graphics_cards=("rtx3060" "rtx3070" "rtx3080" "rtx3090" "rx6700")

# Iterate over the graphics cards and retrieve the sales figures for each card
for graphics_card in "${graphics_cards[@]}"; do
  # Get the sales figures for the current graphics card
  sales=$(get_sales_figures "$graphics_card")

  # Write the sales figures to the sales.txt file
  echo "$graphics_card: $sales" >> sales.txt
done

# Write the current date to the sales.txt file
echo "$(date)" >> sales.txt
