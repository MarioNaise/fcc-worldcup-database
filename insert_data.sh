#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE teams, games")

cat games.csv | while IFS=, read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
  if [[ $YEAR != year ]]
  then
    # check if winner not in db
    WINNER_IN_DB=$($PSQL "SELECT * FROM teams WHERE name = '$WINNER'")
    if [[ -z $WINNER_IN_DB ]]
    then
      # insert
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      echo "Inserted into teams from winners: $WINNER"
    fi
    # check if opponent not in db
    OPPONENT_IN_DB=$($PSQL "SELECT * FROM teams WHERE name = '$OPPONENT'")
    if [[ -z $OPPONENT_IN_DB ]]
    then
      # insert
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      echo "Inserted into teams from opponents: $OPPONENT"
    fi
  fi
done

cat games.csv | while IFS=, read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
  if [[ $YEAR != year ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) values($YEAR, '$ROUND', $WGOALS, $OGOALS, $WINNER_ID, $OPPONENT_ID)")
    echo "Inserted into games: $YEAR, $ROUND, $WINNER : $OPPONENT - $WGOALS : $OGOALS"
  fi
done