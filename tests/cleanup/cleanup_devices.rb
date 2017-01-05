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

# click on Devices\Device Management 
b.element(:text => 'Devices').click()
b.element(:text => 'Device Management').click()

# wait for page to load - look for text on screen = 'Devices Configured'
Watir::Wait.until { b.text.include? 'Devices Configured' }

# get the count of devices
device_count = b.strong(:id => 'device-management-badge-strong', :index => 2)
no_of_devices = device_count.text
no_of_devices = no_of_devices.to_i
if no_of_devices == 0
	puts('No devices to delete...')
else
	no_of_devices = no_of_devices - 1
	for i in 0..no_of_devices
		b.button(:text => 'Delete').click()
		sleep 1
		b.element(:css => '[ng-model="question.tSure"]').send_keys('YES')
		b.checkbox(:index => 0).set()
		sleep 1
		b.button(:text => 'Confirm').click()
		sleep 1
	end
end

# end