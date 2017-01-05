# December 1, 2016
# Delete any existing devices - before running the test(s)

require 'rubygems'
require 'test/unit'
require 'selenium-webdriver'
require '../classes/login'
require 'watir'

# open the browser window
b = Watir::Browser.new :chrome

# read the testing configuration file
testConfig = eval(File.open('../properties/testConfig.rb') {|f| f.read })

# login screen
b.goto(testConfig[:url])
b.window.maximize()

# login
login = Login.new
login.loginInfo(b,'seven10','seven10')

# click on Jobs\Job Management 
b.element(:text => 'Jobs').click()
b.element(:text => 'Job Management').click()

# wait for page to load - look for text on screen = 'Next Scheduled Time'
Watir::Wait.until { b.text.include? 'Next Scheduled Time' }

# find any running jobs and shut them down
running_jobs = b.strong(:id => 'device-management-badge-strong', :index => 1)
no_of_running_jobs = running_jobs.text
no_of_running_jobs = no_of_running_jobs.to_i
if no_of_running_jobs > 0
	no_of_running_jobs = no_of_running_jobs - 1
	for i in 0..no_of_running_jobs
		b.element(:css => '[ng-model="paginate.search"]').send_keys('RUNNING')
		b.element(:css => '[ng-model="paginate.search"]').send_keys(:enter)
		sleep 2
		b.button(:text => 'View').click()
		sleep 1
		b.button(:text => 'Stop').click()
		sleep 1
		b.a(:text => 'Settings').click()
		sleep 1
		Watir::Wait.until { b.text.include? 'Stopped' }
		sleep 1
		b.element(:text => 'Job Management').click()
		sleep 5
	end
else
	puts('No jobs are running...')
end

# delete job(s)
stopped_jobs = b.strong(:id => 'device-management-badge-strong', :index => 2)
no_of_stopped_jobs = stopped_jobs.text
no_of_stopped_jobs = no_of_stopped_jobs.to_i
completed_jobs = b.strong(:id => 'device-management-badge-strong', :index => 3)
no_of_completed_jobs = completed_jobs.text
no_of_completed_jobs= no_of_completed_jobs.to_i
no_of_jobs = no_of_stopped_jobs + no_of_completed_jobs
if no_of_jobs == 0
	puts('No jobs to delete (based on count of Stopped + Completed)...')
else
	no_of_jobs = no_of_jobs - 1
	for i in 0..no_of_jobs
		b.button(:text => 'Delete').click()
		sleep 1
		b.element(:css => '[ng-model="question.tSure"]').send_keys('YES')
		b.checkbox(:index => 0).set()
		sleep 1
		b.button(:text => 'Confirm').click()
		sleep 1
	end
end

# is the table empty?
jobs_in_table1 = b.table(:index => 0).rows.length
if jobs_in_table1 > 1
	puts('Additional jobs to be deleted...')
	jobs_in_table1 = jobs_in_table1 - 1
	for i in 0..jobs_in_table1
		b.button(:text => 'Delete').click()
		sleep 1
		b.element(:css => '[ng-model="question.tSure"]').send_keys('YES')
		b.checkbox(:index => 0).set()
		sleep 1
		b.button(:text => 'Confirm').click()
		sleep 1
	end
else
	puts('No additional jobs to be deleted...')
end

# verify that job table is empty
jobs_in_table2 = b.table(:index => 0).rows.length
if jobs_in_table2 == 1
	puts('All jobs have been deleted...')
else
	puts('Cleanup script failed - Investigate...')
end

# end