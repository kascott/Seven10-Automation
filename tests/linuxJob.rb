# December 1, 2016
# Create/Run Linux job

require 'rubygems'
require 'test/unit'
require 'selenium-webdriver'
require './classes/login'
require './classes/assertions'
require './classes/jobs'
require 'watir'

# read the testing configuration file
testConfig = eval(File.open('./properties/testConfig.rb') {|f| f.read })

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
linuxJob = Jobs.new
random_string = linuxJob.jobNumber(5)
job_number = 'AUTO-SMOKE-LINUX_' + random_string
linuxJob.jobInfo(b,'MIGRATE',job_number,'Created by Automation')
linuxJob.importFile(b,'linux-source','linux-destination','Import File',testConfig[:file_path1])
puts('5,Click Create Job.,The + New Job popuop opens.,Pass')
puts('6,Record the Job Number that is created.,Job Number = ' + job_number + ',Pass')

# run the job
Watir::Wait.until { b.text.include? 'Next Scheduled Time' }
b.element(:css => '[ng-model="paginate.search"]').send_keys(random_string)
b.element(:css => '[ng-model="paginate.search"]').send_keys(:enter)
sleep 2
job_table = b.table(:index => 0)
job_table.button(:index => 0).click()
Watir::Wait.until { b.text.include? 'Cutover Estimate' }
b.button(:text => 'Run').click()
puts('7,Use the filter to find the job that was created above. filter on the following value: ' + random_string  + ', The filter is applied to the job.,Pass')
puts('8,Run the job.,The job starts Running.,Pass')

# verify the source & destination
# system('C:\Users\kscott\Documents\Automation\verify-before.bat > before.txt')

# track the job
puts('9,Track the job through its various stages.,Job is tracked via assertions below.')
linuxJob.jobStatusCheck(b,'job_source','/home/seven10/export/share1')
linuxJob.jobStatusCheck(b,'job_destination','/home/seven10/export/destination1')
linuxJob.jobStatusCheck(b,'job_phase','COPY')
linuxJob.jobStatusCheck(b,'job_status','QUEUED')
linuxJob.jobStatusCheck(b,'job_migration','NOT_STARTED')
sleep 2
linuxJob.waitForStatusChange(b,'QUEUED')
puts('10,Verify that the Job is now running in the COPY phase.,Job is tracked via assertions below.')
linuxJob.jobStatusCheck(b,'job_phase','COPY')
linuxJob.jobStatusCheck(b,'job_status','RUNNING')
linuxJob.jobStatusCheck(b,'job_migration','IN_PROGRESS')
linuxJob.waitForStatusChange(b,'RUNNING')
puts('11,Verify that the Job Numbers during the COPY Phase.,Job Numbers during the COPY phase are listed below:')
linuxJob.jobStats(b,'COPY') # get the copy numbers
linuxJob.jobStatsCheck(b, 'stats_phase','COPY')
linuxJob.jobStatsCheck(b, 'stats_dirs_scanned','9')
linuxJob.jobStatsCheck(b, 'stats_files_scanned','142')
puts('12,Verify that the Job is now in the SMARTSYNC phase.,Job is tracked via assertions below.')
linuxJob.jobStatusCheck(b,'job_phase','SMARTSYNC')
linuxJob.jobStatusCheck(b,'job_status','QUEUED')
linuxJob.jobStatusCheck(b,'job_migration','IN_PROGRESS')
linuxJob.waitForStatusChange(b,'QUEUED')
puts('13,Verify that the Job is now running in the SMARTSYNC phase.,Job is tracked via assertions below.')
linuxJob.jobStatusCheck(b,'job_phase','SMARTSYNC')
linuxJob.jobStatusCheck(b,'job_status','RUNNING')
linuxJob.jobStatusCheck(b,'job_migration','IN_PROGRESS')
linuxJob.waitForStatusChange(b,'RUNNING')
puts('14,Verify that the Job Numbers during the SMARTSYNC Phase.,Job Numbers during the SMARTSYNC phase are listed below:')
linuxJob.jobStats(b,'SMARTSYNC') # get the copy numbers
linuxJob.jobStatsCheck(b, 'stats_phase','SMARTSYNC')
linuxJob.jobStatsCheck(b, 'stats_dirs_scanned','9')
linuxJob.jobStatsCheck(b, 'stats_files_scanned','142')
sleep 3
b.button(:text => 'Stop').click()
puts('15,Stop the job.,Job has started the process to STOP.,Pass')
sleep 1
b.a(:text => 'Settings').click()
sleep 1
Watir::Wait.until { b.text.include? 'Stopped' }
puts('16,Verify the job is completely Stopped.,Job Status = STOPPED.,Pass')
sleep 1
b.a(:text => 'Mappings').click()
sleep 1

# verify destination
#~ system('C:\Users\kscott\Documents\Automation\verify-after.bat > after.txt')

# initiate cutover
linuxJob.setCutover(b)
puts('17,Verify that the Job is now in the CUTOVER phase.,Job is tracked via assertions below.')
linuxJob.jobStatusCheck(b,'job_phase','CUTOVER')
linuxJob.jobStatusCheck(b,'job_status','STOPPED')
linuxJob.jobStatusCheck(b,'job_migration','IN_PROGRESS')
b.button(:text => 'Run').click()
linuxJob.waitForStatusChange(b,'STOPPED')
puts('18,Verify that the Job is now running in the CUTOVER phase.,Job is tracked via assertions below.')
linuxJob.jobStatusCheck(b,'job_phase','CUTOVER')
linuxJob.jobStatusCheck(b,'job_status','RUNNING')
linuxJob.jobStatusCheck(b,'job_migration','IN_PROGRESS')
linuxJob.waitForStatusChange(b,'RUNNING')
puts('19,Verify that the Job is now COMPLETED.,Job is tracked via assertions below.')
linuxJob.jobStatusCheck(b,'job_phase','CUTOVER')
linuxJob.jobStatusCheck(b,'job_status','COMPLETED')
linuxJob.jobStatusCheck(b,'job_migration','COMPLETED')
puts('20,Verify that the Job Numbers during the CUTOVER Phase.,Job Numbers during the CUTOVER phase are listed below:')
linuxJob.jobStats(b,'CUTOVER') # get the copy numbers
linuxJob.jobStatsCheck(b, 'stats_phase','SMARTSYNC')
linuxJob.jobStatsCheck(b, 'stats_dirs_scanned','9')
linuxJob.jobStatsCheck(b, 'stats_files_scanned','142')

# end