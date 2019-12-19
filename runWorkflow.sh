#!/bin/bash

get_answer () {
  echo $1
  select yn in "Yes" "No"; do
    case $yn in
        Yes ) answer=1; return 1; break;;
        No ) answer=2; return 2; break;;
        * ) answer=0; echo "Choose the correct number";;
    esac
  done
}

clean_up () {
  echo "Cleaning up the folders"
  ./nukeEverything.sh
}

generate_all_certs () {
  echo "Generating the Certificates Now"
  cd ./CAUtils
  ./issueRootCerts.sh
  cd ../LeafUtils
  ./issueCSRs.sh
  cd - 1>/dev/null
  ./issueSignedCerts.sh
  cd ..
}

#Start Execution of Script
choiceValue=0

dir1Count=`find CAUtils -type d 2>/dev/null | wc -l `
dir2Count=`find LeafUtils -type d 2>/dev/null | wc -l`

if [ $dir1Count -lt 2 ] || [ $dir2Count -lt 2 ] || [ $dir1Count -gt 2 ] || [ $dir2Count -gt 2 ]
then
  echo "Please run this script from the git repo root folder."
  echo "It has a check which disables execution from anything other than the git repo root folder"
  exit
fi

echo "********************************************************************"
select choiceValue in "Clean Up everything" "Just run it, No questions asked" "Clean up and run the workflow" "Just Exit"; do
  case $choiceValue in
      "Clean Up everything" )
        clean_up
        exit
        ;;
      "Just run it, No questions asked" )
        generate_all_certs
        exit
        ;;
      "Clean up and run the workflow" )
        echo "Cleaning up everything and running the workflow to issue Root and Leaf Certificates and Keys"
        clean_up
        generate_all_certs
        exit
        ;;
      "Just Exit" )
        echo "Exiting"
        exit
        ;;
      * ) choiceValue=0; echo "Choose the correct number";;
  esac
done

if false; then
  if [ $answer -lt 9 ]
  then
    get_answer "Do you want me to run through the checklist for your confirmation"
  fi

  if [ $answer -lt 3 ]
  then
    #The force run switch is not selected, we can ask the questions according to the choice
    if [ $answer -eq 1 ]
    then
      get_answer "Critical: Did you add the host details into ../LeafUtils/hosts.txt"
      if [ $answer -eq 2 ]
      then
        echo "Fill up the details in the file and coma back again."
        exit
      fi
    fi
  fi

  echo "Please make sure the following things were done before running the workflow:"
  echo ""
  echo "1. Updated CA Certificate Password (has been pre-populated for convenience)"
  echo "2. Updated CA Certificate Key Password (has been pre-populated for convenience)"
  echo "3. Updated CA Signing Configuration (has been pre-populated for convenience)"
  echo "4. Updated list of CSR's to be issued (../LeafUtils/hosts.txt - has been pre-populated for convenience)"
  echo "5. Updated Leaf Certificate Key Password (has been pre-populated for convenience)"
fi
