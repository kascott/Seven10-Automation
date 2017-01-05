# December 7, 2016
# Create filters for test purposes

require 'rubygems'
require 'test/unit'
require 'selenium-webdriver'
require '../classes/login'
require 'watir'

# read the testing configuration file
testConfig = eval(File.open('../properties/testConfig.rb') {|f| f.read })

# open the browser window
b = Watir::Browser.new :chrome
	
# login screen
b.goto(testConfig[:url])
b.window.maximize()

# login
login = Login.new
login.loginInfo(b,'seven10','seven10')

# click on Jobs\Job Management 
b.element(:text => 'Jobs').click()
b.element(:text => 'Filter Management').click()

# wait for page to load - look for text on screen = 'Results Per Page'
Watir::Wait.until { b.text.include? 'Results Per Page' }

# is the table empty?
filters_in_table = b.table(:index => 0).rows.length
if filters_in_table > 1
	puts('Delete filters...')
	filters_in_table = filters_in_table - 1
	filters_in_table.times do
		b.button(:text => 'Delete').click()
		sleep 1
	end
else
	puts('No filters to be deleted...')
end

# end