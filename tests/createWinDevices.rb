# December 1, 2016
# Create two Windows Shares for test purposes

require 'rubygems'
require 'test/unit'
require 'selenium-webdriver'
require './classes/assertions'
require './classes/login'
require './classes/devices'
require 'watir'

# read the testing configuration file
testConfig = eval(File.open('./properties/testConfig.rb') {|f| f.read })

# capture test results
# filename = 'results' + Time.now.strftime('%Y-%m-%d_%H-%M-%S') + '.txt'
# results_file = File.new(filename, 'w')

# open the browser window
b = Watir::Browser.new :chrome
	
# login screen
b.goto(testConfig[:url])
b.window.maximize()

# login
login = Login.new
login.loginInfo(b,'seven10','seven10')

# get the build number
build_number = b.div(:class => 'version ng-binding').text()

# click on Devices\Device Management 
b.element(:text => 'Devices').click()
b.element(:text => 'Device Management').click()

# add a source 
device = Devices.new
device.windowsInfo(b,'Microsoft Windows','QA4','Created by Automation')
device.connectionInfo(b,testConfig[:device_address3],'administrator','Seven10Stor','60ISLANDST')
sleep 2
b.button(:text => 'View', :index => 2).click() 
sleep 1
device.resourceDiscovery(b,'SHARE',testConfig[:device_searchstring2])
sleep 1

# add a destination 
b.element(:text => 'Device Management').click()
device.windowsInfo(b,'Microsoft Windows','QA5','Created by Automation')
device.connectionInfo(b,testConfig[:device_address4],'administrator','Seven10Stor','60ISLANDST')
b.button(:text => 'View', :index => 3).click() # watir row_count not working
sleep 1
device.resourceDiscovery(b,'SHARE',testConfig[:device_searchstring3])
sleep 1

# close the results file
# results_file.close()