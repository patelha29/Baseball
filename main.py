import mysql.connector

# Configure database connection
config = {
  'user': 'admin',
  'password': 'assignment4',
  'host': 'baseball.cjxafgabiklm.us-east-1.rds.amazonaws.com',
  'database': 'baseball_db'
}

# Connect to the database
cnx = mysql.connector.connect(**config)
cursor = cnx.cursor()

# Query the player_stats view
query = "SELECT * FROM player_stats"
cursor.execute(query)

print("PLAYER STATS:")
for row in cursor:
  print(row)

# Query the team_stats view  
query = "SELECT * FROM team_stats"
cursor.execute(query)

print("\nTEAM STATS:")
for row in cursor:
  print(row)

# Close database connection
cnx.close()