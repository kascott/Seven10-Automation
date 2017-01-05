# December 22, 2016
# Filter test - create after

require 'rubygems'
require 'test/unit'
require 'selenium-webdriver'
require './classes/login'
require './classes/assertions'
require './classes/filters'
require './classes/jobs'
require 'watir'

# read the testing configuration file
testConfig = eval(File.open('./properties/testConfig.rb') {|f| f.read })

# look at destination
filter = Filters.new
filter.destinationClean(testConfig[:filter_destination6],testConfig[:filter_destination6A],testConfig[:filter_clean6])

# look at the source
puts('Testing Max File Size filter...')
filter.sourceCheck(testConfig[:filter_source6],testConfig[:filter_source6A],testConfig[:filter06],testConfig[:filter_source6B],testConfig[:filter_source6C])

# open the browser window
b = Watir::Browser.new :chrome
	
# login screen
b.goto(testConfig[:url])
b.window.maximize()
puts('1,Go to ' + testConfig[:url].to_s + ' ,Storfirst Migration successfully opens.,Pass')

# login
login = Login.new
login.loginInfo(b,'seven10','seven10')
puts('2,Login in as seven10., User seven10 is successfully logged in SFM.,Pass')

# get the build number
build_number = b.div(:class => 'version ng-binding').text()
puts('3,Verfiy the version under test.,Build Number -' + build_number)

# click on Jobs\Job Management 
b.element(:text => 'Jobs').click()
b.element(:text => 'Job Management').click()
puts('4,Go to Jobs\Job Management.,The Job Management screen opens.,Pass')
sleep 1
b.element(:text => 'Create Job').click()

# create a job
windowsJob = Jobs.new
random_string = windowsJob.jobNumber(5)
job_number = 'AUTO-FILTER-TEST_' + random_string
windowsJob.jobInfo(b,'MIGRATE',job_number,'Created by Automation - Filter = Create after date (12/8/16)')
windowsJob.importFile(b,'QA4','QA5','Import File',testConfig[:file_path6])
puts('5,Click Create Job.,The + New Job popuop opens.,Pass')
puts('6,Record the Job Number that is created.,Job Number = ' + job_number + ',Pass')

# edit the job and apply the filter
Watir::Wait.until { b.text.include? 'Next Scheduled Time' }
b.element(:css => '[ng-model="paginate.search"]').send_keys(random_string)
b.element(:css => '[ng-model="paginate.search"]').send_keys(:enter)
sleep 2
job_table = b.table(:index => 0)
job_table.button(:index => 0).click()
Watir::Wait.until { b.text.include? 'Cutover Estimate' }
b.button(:text => 'Update Mapping Settings').click()
Watir::Wait.until { b.text.include? 'View Path List Info' }
b.checkbox(:index => 0).set() # create a static job
b.button(:text => 'Update').click()
sleep 1
b.link(:text => 'Settings').click()
b.button(:text => 'Edit').click()
sleep 1
b.a(:text => 'Advanced Settings',:index => 1).click()
sleep 1
b.button(:css => '[ng-click="toggleDropdown()"]',:index => 1).click()
sleep 1
b.send_keys :tab
sleep 2
b.send_keys ['Maximum']
b.ul(:class => 'dropdown-menu dropdown-menu-form',:index => 1).checkbox(:index => 0).set()
b.button(:text => 'Update').click()

# run the job
Watir::Wait.until { b.text.include? 'Not Started' }
b.button(:text => 'Run').click()
puts('7,Use the filter to find the job that was created above. filter on the following value: ' + random_string  + ', The filter is applied to the job.,Pass')
puts('8,Run the job.,The job starts Running.,Pass')
Watir::Wait.until (180) { b.text.include? 'Running' }
Watir::Wait.until (180) { b.text.include? 'Stopped' }
b.a(:text => 'Mappings').click()

# look at the destination
filter.destinationCheckExclude(testConfig[:filter_destination6],testConfig[:filter_destination6A],testConfig[:filter06],testConfig[:filter_destination6B],testConfig[:filter_destination6C])

# end