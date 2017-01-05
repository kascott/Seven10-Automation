# December 7, 2016
# Create filters for test purposes

require 'rubygems'
require 'test/unit'
require 'selenium-webdriver'
require './classes/login'
require './classes/filters'
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
puts build_number

# click on Jobs\Filter Management 
b.element(:text => 'Jobs').click()
b.element(:text => 'Filter Management').click()

# create a filter - exclude files
filter = Filters.new
filter.filterName(b,'Exclude Files','Created by Automation')
filter.filterExclude(b,'*.dat')
filter.filterCreate(b)

# include files
filter.filterName(b,'Include Files','Created by Automation')
filter.filterInclude(b,'*.txt')
filter.filterCreate(b)

# min file size
filter.filterName(b,'Minimum File Size','Created by Automation')
filter.filterMinSize(b,'20480')
filter.filterCreate(b)

# max file size
filter.filterName(b,'Maximum File Size','Created by Automation')
filter.filterMaxSize(b,'20480')
filter.filterCreate(b)

# end