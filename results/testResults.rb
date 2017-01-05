require './reporting'
require 'csv'

data = CSV.read("./results_2016-12-01_15-11-07.csv", { encoding: "UTF-8", headers: false, header_converters: :symbol, converters: :all})
hashed_data = data.map { |d| d.to_a }
#puts hashed_data
puts hashed_data.size
puts hashed_data.length
puts hashed_data[0][1]

create_report
insert_head_title("Storfirst Migration -- Sample HTML Report")
insert_reportname_date("My Test Report",$result_date )
start_table
report_row(hashed_data[0][0],hashed_data[0][1],hashed_data[0][2],hashed_data[0][3],hashed_data[0][4])
#report_row(hashed_data[2]),hashehashed_data[0][1]hashed_data[0][1]hashed_data[0][1]hashed_data[0][1]d_data[0][1]
close_table
summary_report(2,1,1)