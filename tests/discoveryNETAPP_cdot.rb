# December 1, 2016
# Create/Run Discovery Job

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
discoverJob = Jobs.new
random_string = discoverJob.jobNumber(5)
job_number = 'AUTO-DISCOVERY-NetApp_cmode_' + random_string
discoverJob.discoverInfo(b,'DISCOVERY',job_number,'Created by Automation','NetApp ONTAP')
discoverJob.discoverMC(b,'192.168.27.1','admin','Seven!0Stor')
discoverJob.discoverDC(b,'Administrator','Seven10Stor','60ISLANDST')
puts('5,Click Create Job.,The + New Job popuop opens. Be sure to select Discovery.,Pass')
puts('6,Record the Job Number that is created.,Job Number = ' + job_number + ',Pass')

# run the job
Watir::Wait.until { b.text.include? 'Next Scheduled Time' }
b.element(:css => '[ng-model="paginate.search"]').send_keys(random_string)
b.element(:css => '[ng-model="paginate.search"]').send_keys(:enter)
sleep 2
job_table = b.table(:index => 0)
job_table.button(:index => 0).click()
Watir::Wait.until { b.text.include? 'QTrees Discovered' }
b.button(:text => 'Run').click()
puts('7,Use the filter to find the job that was created above. filter on the following value: ' + random_string  + ', The filter is applied to the job.,Pass')
puts('8,Run the job.,The job starts Running.,Pass')

# wait for job to complete and get the numbers
Watir::Wait.until(180) { b.text.include? 'COMPLETED' }
puts('9,The Discovery job completes successfully.,Verify the counts against the screenshot.')
shares_discovered = b.strong(:id => 'device-management-badge-strong').text()
exports_discovered = b.strong(:id => 'device-management-badge-strong',:index => 1).text()
qtrees_discovered = b.strong(:id => 'device-management-badge-strong',:index => 2).text()
volumes_discovered = b.strong(:id => 'device-management-badge-strong',:index => 3).text()
puts('10,Record the number of shares discovered.,Number of Shares Discovered = ' + shares_discovered) 
puts('11,Record the number of exports discovered.,Number of Exports Discovered = ' + exports_discovered) 
puts('12,Record the number of qtrees discovered.,Number of QTrees Discovered = ' + qtrees_discovered)
puts('13,Record the number of volumes discovered.,Number of Volumes Discovered = ' + volumes_discovered) 

# grab a screenshot
b.screenshot.save('./screenshot/device-netapp.png')
