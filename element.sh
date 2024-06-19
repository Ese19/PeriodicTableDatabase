#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then 
  echo Please provide an element as an argument.
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_RESULT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE atomic_number = $1") 
  else
    ELEMENT_RESULT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE symbol = '$1' or name = '$1'")
  fi

  if [[ -z $ELEMENT_RESULT ]]
  then
    echo -e "I could not find that element in the database."
  else
    echo "$ELEMENT_RESULT" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME
    do
      ELEMENT_PROPERTIES=$($PSQL "SELECT type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN types USING (type_id) WHERE atomic_number=$ATOMIC_NUMBER")
      
      if [[ -z $ELEMENT_PROPERTIES ]]
      then
        echo "I could not find that element in the database."
      else
        echo "$ELEMENT_PROPERTIES" | while IFS="|" read TYPE MASS MELTING_POINT BOILING_POINT
        do
          echo  "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        done
      fi

     done 
  fi


fi