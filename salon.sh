#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e  "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo "Welcome to My Salon, how may I help you?"
  echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim\n6) Exit"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) CUT_MENU ;;
    2) COLOR_MENU ;;
    3) PERM_MENU ;;
    4) STYLE_MENU ;;
    5) TRIM_MENU ;;
    6) EXIT ;;
    *) MAIN_MENU "Please enter a valid option";;
  esac

}

APPOINTMENT(){
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  #check for number in db
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  if [[ -z $CUSTOMER_ID ]]
  then
    echo -e "\nYou are not in our database"
    #get user name
    echo -e "\nPlease give us your name to signup"
    read CUSTOMER_NAME

    #create a new Customer
    NEW_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')");
  fi
    echo -e "\nWhat time would you like your $1 appointment"
    read SERVICE_TIME

    #Check for customer id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

    #CREATE APPOINTMENTS
    NEW_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    echo -e "\nI have put you down for a $1 at $SERVICE_TIME, $CUSTOMER_NAME."
}



CUT_MENU() {
  APPOINTMENT cut
}

COLOR_MENU() {
  APPOINTMENT color
}

PERM_MENU() {
  APPOINTMENT perm
}

STYLE_MENU() {
  APPOINTMENT style
}

TRIM_MENU() {
  APPOINTMENT trim
}
 
EXIT(){
  echo "Thanks for visiting."
}

MAIN_MENU