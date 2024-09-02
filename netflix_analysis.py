# Importing pandas and matplotlib
import pandas as pd
import matplotlib.pyplot as plt

# Read in the Netflix CSV as a DataFrame
netflix_df = pd.read_csv("netflix_data.csv")

# Subset the DataFrame for type "Movie"
netflix_movies_subset = netflix_df[netflix_df["type"] == "Movie"]

# Filtering the netflix_subset to keep only movies released in the 1990s
movies_1990s = netflix_movies_subset[(netflix_movies_subset["release_year"] >= 1990) & (netflix_movies_subset["release_year"] < 2000)]

# Visualizing the duration column of filtered data to see the distribution of movie durations
plt.hist(movies_1990s["duration"])
plt.title('Distribution of Movie Durations in the 1990s')
plt.xlabel('Duration (minutes)')
plt.ylabel('Number of Movies')
plt.show()

duration = 100

# Filtering the dataframe again to keep only the Action movies
action_movies_1990s = movies_1990s[movies_1990s["genre"] == "Action"]

# Using a for loop and a counter to count how many short action movies there were in the 1990s
# Start the counter
# Iterate over the labels and rows of the DataFrame and check if the duration is less than 90, if it is, add 1 to the counter, if it isn't, the counter should remain the same
short_action_movies = 0
for lab, row in action_movies_1990s.iterrows():
    if row["duration"] < 90:
        short_action_movies = short_action_movies + 1
    else:
         short_action_movies = short_action_movies
# Print the count
print("Number of short action movies from the 1990s:", short_action_movies)


# A quicker way of counting values in a column is to use .sum() on the desired column
# (action_movies_1990s["duration"] < 90).sum()