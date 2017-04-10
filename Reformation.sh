## You must give permission to execute the file: chmod 700 Reformation.sh 
## Do note overwrite the original 'file'.csv.

## Create or set your directory where you want to save your files.csv.

# mkdir /home/pgbook/FinalAssignment 
# cd /home/pgbook/FinalAssignment

# reformation of file cc.csv to ccnew.csv
sed 's/,/,"/1;s/\(,[^,]*,[^,]*\)$/"\1/;s/""/"NONE"/' cc.csv > ~/FinalAssignment/ccnew.csv

# reformation of file assigned_to.csv to assignedtonew.csv
sed 's/,/,"/1;s/\(,[^,]*,[^,]*\)$/"\1/' assigned_to.csv > ~/FinalAssignment/assignedtonew.csv

# reformation of file short_desc.csv to shortdescnew.csv
sed 's/,/,"/1;s/\(,[^,]*,[^,]*\)$/"\1/' short_desc.csv > ~/FinalAssignment/shortdescnew.csv

# reformation of file component.csv to componentnew.csv
sed 's/,/,"/1;s/\(,[^,]*,[^,]*\)$/"\1/' component.csv > ~/FinalAssignment/componentnew.csv

# reformation of file op_sys.csv to opsysnew.csv
sed 's/,/,"/1;s/\(,[^,]*,[^,]*\)$/"\1/' op_sys.csv > ~/FinalAssignment/opsysnew.csv

# reformation of file resolution.csv to resolutionnew.csv
sed 's/,/,"/1;s/\(,[^,]*,[^,]*\)$/"\1/;s/""/"NONE"/' resolution.csv > ~/FinalAssignment/resolutionnew.csv

# reformation of file version.csv to versionnew.csv
sed 's/,/,"/1;s/\(,[^,]*,[^,]*\)$/"\1/' version.csv > ~/FinalAssignment/versionnew.csv

# reformation of file reports.csv to reportsnew.csv
sed 's/,/,"/1;s/,/","/2;s/,/",/3;s/""/"NONE"/' reports.csv > ~/FinalAssignment/reportsnew.csv
