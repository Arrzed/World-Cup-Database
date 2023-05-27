#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # get winning and losing teams
    WIN_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name ='$WINNER'")
    OPP_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name ='$OPPONENT'")

    # if winning team not found
    if [[ -z $WIN_TEAM ]]
    then
      INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      WIN_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name ='$WINNER'")
    fi

    # if opponent team not found
    if [[ -z $OPP_TEAM ]]
    then
      INSERT_LOSER=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      OPP_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name ='$OPPONENT'")
    fi

    # insert games
    INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WIN_TEAM', '$OPP_TEAM', '$WINNER_GOALS', '$OPPONENT_GOALS')")
  fi
done
