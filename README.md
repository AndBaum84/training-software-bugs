# training-software-bugs with machine learning
Explore the Eclipse defect tracking dataset to develop insight into the factors that affect the likelihood of a bug being fixed. With this understanding, three different prediction models (Naive-bayes, support vector machine, logistic regression) are applied for which bugs would be fixed. 

Data:
  - Available Data: see DataStructure.pdf
  - Bug process: see lifecycle_bug.pdf

  The raw data provided by eclipse can be characterized as follows:
  - The raw data consists of 11 different csv. files which can only be matched with the bug ID.
  - Therefore, we had to build up a database from which we can extract the relevant data for our models later on.
  - In particular, we wanted a table where you get relevant the characteristics for every bug.

  In order to read the data into our SQL database, we had to clean it by running
  shell-scripts executing sed-commands to substitute, replace or delete
  characters. The problems which mainly occured were:
  - In the cc.csv file, more than one email adress, seperated with a comma, was specified in one row.
  - We found special characters as well as commas in the description in the file "short_desc.csv".
  - In many csv-files we detected several emtpy entries which had to be filled with "NONE".
  
  Database:
    Building up the database is straight forward:
    - The structure of every table is:
      - The primary key consists of the bug ID and the variable UPDATDE_TIME. In most cases this was enough to create a unique identifier.
      - If the primary key was not unique, we added other variables to the primary key.
      - The foreign key is the bug ID for every table.
    - For our purpose we neglected the table short_description.csv since we cannot use the information in the text in an efficient way for our models.
    
Procedure:
  - Create Database: see CreateDB.pdf
  - Flow-process: see FinalFlowchart.pdf
