# Import libraries
import pandas as pd
import seaborn as sns
import numpy as np
import matplotlib 
import matplotlib.pyplot as plt
plt.style.use('ggplot')
from matplotlib.pyplot import figure
matplotlib.rcParams['figure.figsize'] = (12,8)

# Reading the data
df = pd.read_csv('movies.csv')
df.head(5)

# Checking for missing values
missing_values = df.isna().sum()
print(missing_values)

#There are missing values 

#Checking data types
print(df.dtypes)

#Handling missing values
# Impute missing values
df['rating'].fillna('Not Rated', inplace=True)  
df['released'].fillna('Unknown', inplace=True)  
df['score'].fillna(df['score'].median(), inplace=True)
df['votes'].fillna(df['votes'].median(), inplace=True)
df['writer'].fillna('Unknown', inplace=True)
df['star'].fillna('Unknown', inplace=True)
df['country'].fillna('Unknown', inplace=True)
df['budget'].fillna(df['budget'].median(), inplace=True)
df['gross'].fillna(df['gross'].median(), inplace=True)
df['company'].fillna('Unknown', inplace=True)
df['runtime'].fillna(df['runtime'].median(), inplace=True)

# Checking the result
print(df.isna().sum())

#Changing data type of column
df['budget'] = df['budget'].astype('int64')
df['gross'] = df['gross'].astype('int64')
df

#Ordering table by gross
df = df.sort_values(by='gross', inplace=False, ascending=False)
df

#Allowing display all the data in dataframe table
#pd.set_option('display.max_rows', None)

#Stopping display of all the data in dataframe table
#pd.set_option('display.max_rows', 0)

#Checking for duplicate 
df.duplicated().sum()

#Dropping any duplicates
df.drop_duplicates(inplace=True)

#Scatter plot with budget and gross
plt.scatter(x=df['budget'], y=df['gross'])
plt.title('Budget and Gross')
plt.xlabel('Gross Earnings')
plt.ylabel('Budget for Film')
plt.show()

# Ploting the budget vs gross using seaborn
sns.regplot(x='budget', y='gross', data=df, scatter_kws={"color": "red"}, line_kws={"color": "blue"})

#Correlation
numeric_df = df.select_dtypes(include=[float, int])
numeric_df.corr(method='pearson') # different method: pearson, kendall, spearman

# High correlation between budget and gross in the correlation matrix

#visualizing the correlation matrix
correlation_matrix = numeric_df.corr(method='pearson')
sns.heatmap(correlation_matrix, annot=True, cmap='coolwarm', square=True)
plt.title('Correlation Matrix for Numeric Feature')
plt.xlabel('Movie Features')
plt.ylabel('Movie Feature')
plt.show()


# Converting columns to numeric
df_numerized = df

for col_name in df_numerized:
    if(df_numerized[col_name].dtype == 'object'):
        df_numerized[col_name] = df_numerized[col_name].astype('category')
        df_numerized[col_name] = df_numerized[col_name].cat.codes

df_numerized

#visualizing the correlation matrix for converted columns
correlation_matrix = df_numerized.corr(method='pearson')
sns.heatmap(correlation_matrix, annot=True, cmap='coolwarm', square=True)
plt.title('Correlation Matrix for Numeric Feature')
plt.xlabel('Movie Features')
plt.ylabel('Movie Feature')
plt.show()

df_numerized.corr()

# Ordering correlation_matrix
corr_matrix = df_numerized.corr()
corr_pairs = correlation_matrix.unstack()
corr_pairs

sorted_pairs = corr_pairs.sort_values()
sorted_pairs

high_corr = sorted_pairs[(sorted_pairs) > 0.5]
high_corr

# Gross and budget have the highest correlation to gross earnings