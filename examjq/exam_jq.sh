

#!/bin/bash

echo "1. Display the number of attributes per document as well as the name attribute. How many attributes do they have? Display only the first 12 lines with the head command."

# Command to respond to question 1
jq -r 'keys[]' people.json | while read key; do echo "$(jq ".$key | length" people.json) attributes"; done | head -n 12

echo -e "\n--------------------------------------\n"

echo "2. How many 'unknown' values are there for the 'birth_year' attribute? Use the tail command to isolate the response."

# Command to respond to question 2
jq '.[] | select(.birth_year == "unknown")' people.json | wc -l

echo -e "\n--------------------------------------\n"

echo "3. Display each character's creation date and name. The creation date must be in the format: year, month, and day. Display only the first 10 lines."

# Command to respond to question 3
jq -r '.[] | "\(.created_at | strptime("%Y-%m-%dT%H:%M:%S.%L%z") | strftime("%Y, %m, %d")): \(.name)"' people.json | head -n 10

echo -e "\n--------------------------------------\n"

echo "4. Some characters are born at the same time. Find all the pairs of IDs (2 IDs) of the characters born at the same time."

# Command to respond to question 4
jq -r '.[] | select(.birth_year != "unknown") | "\(.birth_year): \(.id)"' people.json | sort | uniq -d

echo -e "\n--------------------------------------\n"

echo "5. Return the number of the first movie each character was seen in followed by the character's name. Display only the first 10 lines."

# Command to respond to question 5
jq -r '.[] | "First movie: \(.seen_movies[0]), Name: \(.name)"' people.json | head -n 10

echo -e "\n--------------------------------------\n"

echo -e "\n----------------BONUS----------------\n"

# Create the bonus folder if it doesn't exist
mkdir -p bonus

echo "6. Delete documents where the height attribute is not a number."

# Command to respond to bonus question 1
jq 'map(select(.height | type == "number" or .height == "unknown"))' people.json > bonus/people_6.json

echo "7. Transform the height attribute into a number."

# Command to respond to bonus question 2
jq '.[] | .height |= (if type == "string" then (tonumber? // .) else . end)' bonus/people_6.json > bonus/people_7.json

echo "8. Return only characters whose height is between 156 and 171."

# Command to respond to bonus question 3
jq '.[] | select(.height >= 156 and .height <= 171)' bonus/people_7.json > bonus/people_8.json

echo "9. Return the smallest individual from people_8.json and display this sentence in one command: '<character_name> is <height> tall'. Save in people_9.txt."

# Command to respond to bonus question 4
jq -r 'min_by(.height) | "\(.name) is \(.height) tall"' bonus/people_8.json > bonus/people_9.txt
