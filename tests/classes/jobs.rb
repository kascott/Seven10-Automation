class Jobs 
	
	def jobNumber(number)
		@number = number
		charset = Array('A'..'Z') + Array('a'..'z')
  		Array.new(@number) { charset.sample }.join
	end

	def discoverInfo(browser,jobType,jobName,jobDescription,device)
		@b = browser
		@jobType = jobType
		@jobName = jobName
		@jobDescription = jobDescription
		@device = device
		@b.div(:class => 'modal-content').select_list(:css => '[ng-model="newJob.type"]').select(@jobType)
		sleep 1
		@b.element(:css => '[ng-click="setNextView()"]').click()
		Watir::Wait.until { @b.text.include? 'Description' }
		count = 0
		while @b.element(:css => '[ng-model="discovery.name" ]').value != "" && count < 50
  			@b.element(:css => '[ng-model="discovery.name" ]').send_keys(:backspace)
  			count += 1
		end
		@b.element(:css => '[ng-model="discovery.name" ]').send_keys(@jobName)
		@b.element(:css => '[ng-model="discovery.description" ]').send_keys(@jobDescription)
		@b.select_list(:name => 'source').select(@device)
		sleep 2
	end

	def discoverMC(browser,discoverAddress,discoverName,discoverPassword)
		@b = browser
		@discoverAddress = discoverAddress
		@discoverName = discoverName
		@discoverPassword = discoverPassword 
		@b.element(:name => 'address').send_keys(@discoverAddress)
		@b.text_field(:name => 'username',:index => 2).set(@discoverName)
		@b.element(:name => 'password').send_keys(@discoverPassword)
	end

	def discoverDC(browser,discoverUser,discoverPass,discoverDom)
		@b = browser
		@discoverUser = discoverUser
		@discoverPass = discoverPass
		@discoverDom = discoverDom 
		@b.text_field(:name => 'username',:index => 3).set(@discoverUser)
		@b.element(:name => 'data_password').send_keys(@discoverPass)
		@b.element(:name => 'data_domain').send_keys(@discoverDom)
		sleep 1
		@b.element(:css => '[ng-click="setNextView()"]').click()
		Watir::Wait.until { @b.text.include? 'Add Schedule' }
		@b.element(:css => '[ng-click="setNextView()"]').click()
	end


	def jobInfo(browser,jobType,jobName,jobDescription)
		@b = browser
		@jobType = jobType
		@jobName = jobName
		@jobDescription = jobDescription
		@b.div(:class => 'modal-content').select_list(:css => '[ng-model="newJob.type"]').select(@jobType)
		sleep 1
		@b.element(:css => '[ng-click="setNextView()"]').click()
		Watir::Wait.until { @b.text.include? 'Description' }
		@b.element(:css => '[ng-model="newJob.name" ]').send_keys(@jobName)
		@b.element(:css => '[ng-model="newJob.description"]').send_keys(@jobDescription)
		sleep 1
		@b.element(:css => '[ng-click="setNextView()"]').click()
	end

	def importFile(browser,source,destination,importType,mappingFile)
		@b = browser
		@source = source
		@destination = destination
		@importType = importType
		@mappingFile = mappingFile
		Watir::Wait.until { @b.text.include? 'Source Device' }
		@b.select_list(:css => '[ng-model="sourceDeviceSelection"]').select(@source)
		@b.select_list(:css => '[ng-model="destinationDeviceSelection"]').select(@destination)
		sleep 1
		@b.element(:css => '[ng-click="setNextView()"]').click()
		Watir::Wait.until { @b.text.include? 'Resource Mapping Selection' }
		@b.select_list(:css => '[ng-model="formData.mappingTypeSelected"]').select(@importType)
		sleep 1
		@b.file_field(:index => 0).set(@mappingFile)
		sleep 1
		@b.element(:css => '[ng-click="setNextView()"]').click()
		Watir::Wait.until { @b.text.include? 'Scanner' }
		@b.element(:css => '[ng-click="setNextView()"]').click()
		Watir::Wait.until { @b.text.include? 'Add Schedule' }
		@b.element(:css => '[ng-click="setNextView()"]').click()
	end

	def jobStatusCheck(browser,value1,value2)
		@b = browser
		@value1 = value1
		@value2 = value2
		job_table = @b.table(:class => 'table table-condensed')
		job_source = job_table[1][0]
		job_destination = job_table[1][1]
		job_phase = job_table[1][2]
		job_status = job_table[1][3]
		job_migration = job_table[1][4]
		if @value1 == 'job_source'
			assert('Job Source = ' + job_source.text) { job_source.text == @value2 }
		elsif @value1 == 'job_destination'
			assert('Job Destination = ' + job_destination.text) { job_destination.text == @value2 }
		elsif @value1 == 'job_phase'
			assert('Job Phase = ' + job_phase.text) { job_phase.text == @value2 }
		elsif @value1 == 'job_status'
			assert('Job Status = ' + job_status.text) { job_status.text == @value2 }
		elsif @value1 == 'job_migration'
			assert('Job Migration = ' + job_migration.text) { job_migration.text == @value2 }
		else
			puts('Error - check values under comparsion.')	
		end	
	end

	def waitForStatusChange(browser,jobstatus)
		@b = browser
		@jobstatus = jobstatus
		job_table = @b.table(:class => 'table table-condensed')
		job_status = job_table[1][3]
		while job_status.text == @jobstatus
			@b.button(:css => '[ng-click="refreshData()').click()
			sleep 2
		end
	end

	def jobStats(browser,searchstring)
		@b = browser
		@searchstring = searchstring
		job_table = @b.table(:class => 'table table-condensed')
		if not @b.table(:index => 1).exists?
			job_table[1][5].click() # click statistics
		end
		sleep 2
		@b.text_field(:css => '[ng-model="search"]' , :index => 1).send_keys(@searchstring)
		sleep 2
	end

	def jobStatsCheck(browser,value1,value2)
		@b = browser
		@value1 = value1
		@value2 = value2
		job_statistics = @b.table(:index => 1)
		stats_phase = job_statistics[1][2]
		stats_dirs_scanned = job_statistics[1][3]
		stats_files_scanned = job_statistics[1][5]
		if @value1 == 'stats_phase'
			assert('Phase = ' + stats_phase.text) { stats_phase.text == @value2 } 
		elsif @value1 == 'stats_dirs_scanned'
			assert('Directories scanned = ' + stats_dirs_scanned.text) { stats_dirs_scanned.text == @value2 }
		elsif @value1 == 'stats_files_scanned'
			assert('Files Scanned = ' + stats_files_scanned.text) { stats_files_scanned.text == @value2 }
		else
			puts('Error - check values under comparsion.')	
		end	
	end

	def setCutover(browser)
		@b.button(:text => 'Initiate Cutover').click()
		sleep 2
		@b.checkbox(:css => '[ng-model="mapping.selected"]').set()
		sleep 1 
		@b.button(:text => 'Submit').click()
	end

end