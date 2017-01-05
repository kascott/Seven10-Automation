def get_time_name
	$time=Time.now
	$time_name="#{$time.hour.to_s}-#{$time.min.to_s}-#{$time.sec.to_s}-#{$time.day.to_s}-#{$time.mon.to_s}-#{$time.year.to_s}"
	$result_date = "#{$time.day.to_s}-#{$time.month.to_s}-#{$time.year.to_s}"
end

def create_report
	get_time_name
	@result_file_name="Report"+"-"+$time_name
	@full_file_name="html/#{@result_file_name}.html"
	$report=File.open(@full_file_name,'w')
	end

def insert_head_title(title)
	$report.puts "<html><head>
	<title> #{title} </title>
	</head>"
end

def start_table
	$report=File.open(@full_file_name,'a')
	$report.puts "<table border=1>
	<tr>
	<th>ID</th>
	<th>Test Steps Name</th>
	<th>Expected Result/th>
	<th>P/F</th>
	<th>Comments</th>
	</tr>"
	$report.close
end

def insert_reportname_date(name,date)
	$report.puts "<body bgcolor='#5CB3FF'>
	<p align='left' size=2>
	</p>
	<p size=12>
	<center> <b><u>#{name} </u></b></center>
	</p>
	<p align='right' size=12>
	<b>Date: #{date} </b>
	</p>"
	$report.close
end

def report_row(*details)
	$report=File.open(@full_file_name,'a')
	name=details[0]
	desc=details[1]
	browser=details[2]
	result=details[3]
	reason=details[4]
	if result.downcase == "pass"
		$report.puts "<tr>
		<td>#{name}</td>
		<td> #{desc}</td>
		<td> #{browser} </td>
		<td bgcolor='green'>#{result}</td>
		<td>#{reason}</td>
		</tr>"
	else
		$report.puts "<tr>
		<td>#{name}</td>
		<td> #{desc}</td>
		<td> #{browser} </td>
		<td bgcolor='red'>#{result}</td>
		<td>#{reason}</td>
		</tr>"
	end
	$report.close
end

def close_table
	$report=File.open(@full_file_name,'a')
	$report.puts "</table></br>"
	$report.close
end

def summary_report(overall,passed,failed)
	$report_overall=overall
	$report_pass=passed
	$report_fail=failed
	$report=File.open(@full_file_name,'a')
	$report.puts "<p> <b>Total Test cases : #{$report_overall} </b></p>
	<p> <b>Passed : #{$report_pass} </b></p>
	<p> <b>Failed : #{$report_fail} </b></p>
	</body>
	</html>"
	$report.close
end

