#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]
then
  if [[ $1 != [a-zA-Z]* ]]
  then
    #based on atomic number
    INPUT_TYPE='atomic_number'
  elif [[ $1 =~ ^[a-zA-Z]{1,2}$ ]]
  then
    #based on symbol
    INPUT_TYPE='symbol'
  else
    #based on name
    INPUT_TYPE='name'
  fi

  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE $INPUT_TYPE='$1';")

  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo I could not find that element in the database.
  else
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE $INPUT_TYPE='$1';")
    NAME=$($PSQL "SELECT name FROM elements WHERE $INPUT_TYPE='$1';")
    TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties ON types.type_id = properties.type_id INNER JOIN elements ON properties.atomic_number = elements.atomic_number WHERE elements.$INPUT_TYPE='$1';")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties INNER JOIN elements ON properties.atomic_number = elements.atomic_number WHERE elements.$INPUT_TYPE='$1';")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties INNER JOIN elements ON properties.atomic_number = elements.atomic_number WHERE elements.$INPUT_TYPE='$1';")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties INNER JOIN elements ON properties.atomic_number = elements.atomic_number WHERE elements.$INPUT_TYPE='$1';")

    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi

else
  echo Please provide an element as an argument.
fi
