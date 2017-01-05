
class Devices  
	
	def linuxInfo(browser,deviceType,deviceName,deviceDescription)
		@b = browser
		@deviceType = deviceType
		@deviceName = deviceName
		@deviceDescription = deviceDescription
		Watir::Wait.until { @b.text.include? 'Add Device' }
		@b.link(:text => 'Add Device').click()
		Watir::Wait.until { @b.text.include? 'New Device Selection' }
		@b.select_list(:css => '[ng-model="device.type"]').select(@deviceType)
		sleep 1
		@b.a(:id => 'nextButton').click()
		Watir::Wait.until { @b.text.include? 'New Linux Device Configuration' }
		@b.element(:css => '[ng-model="addDevice.device_post_request.name"]').send_keys(@deviceName)
		@b.element(:css => '[ng-model="addDevice.device_post_request.description"]').send_keys(@deviceDescription)
		sleep 1
		@b.button(:id => 'nextButton').click()
	end

	def windowsInfo(browser,deviceType,deviceName,deviceDescription)
		@b = browser
		@deviceType = deviceType
		@deviceName = deviceName
		@deviceDescription = deviceDescription
		Watir::Wait.until { @b.text.include? 'Add Device' }
		@b.link(:text => 'Add Device').click()
		Watir::Wait.until { @b.text.include? 'New Device Selection' }
		@b.select_list(:css => '[ng-model="device.type"]').select(@deviceType)
		sleep 1
		@b.a(:id => 'nextButton').click()
		Watir::Wait.until { @b.text.include? 'New Microsoft Windows Device Configuration' }
		@b.element(:css => '[ng-model="addDevice.device_post_request.name"]').send_keys(@deviceName)
		@b.element(:css => '[ng-model="addDevice.device_post_request.description"]').send_keys(@deviceDescription)
		sleep 1
		@b.button(:id => 'nextButton').click()
	end

	def connectionInfo(browser,address,username,password,domain)
		@b = browser
		@address = address
		@username = username
		@password = password
		@domain = domain
		Watir::Wait.until { @b.text.include? 'Management Connection' }
		@b.element(:css => '[ng-model="device.address"]').send_keys(@address)
		@b.element(:css => '[ng-model="addDevice.device_post_request.mgmt_user"]').send_keys(@username)
		@b.element(:css => '[ng-model="addDevice.device_post_request.mgmt_pass"]').send_keys(@password)
		@b.element(:css => '[ng-model="addDevice.device_post_request.domain"]').send_keys(@domain)
		@b.element(:css => '[ng-model="device.data_management_same"]').click()
		sleep 1
		@b.button(:id => 'nextButton').click()
		Watir::Wait.until { @b.text.include? 'Management Username:' }
		@b.button(:id => 'submitButton').click()
		sleep 2
	end

	def resourceDiscovery(browser,sharetype,searchstring)
		@b = browser
		@sharetype = sharetype
		@searchstring = searchstring	
		Watir::Wait.until { @b.text.include? 'Discover Resources' }
		@b.i(:css => '[ng-click="discoverResources()"]').click()
		Watir::Wait.until { @b.text.include? 'NOTE: Any configured resources will not be visible in the results.' }
		@b.div(:class => 'modal-content').select_list(:id => 'resourceSelect').select(@sharetype)
		sleep 1
		@b.button(:text => 'Discover Resources').click()
		sleep 2
		if @b.div(:class => 'cg-busy cg-busy-animation ng-scope').exists? 
			if @b.div(:class => 'cg-busy cg-busy-animation ng-scope').visible? 
				while @b.div(:class => 'cg-busy cg-busy-animation ng-scope').visible?
					sleep 1
				end
			end
		end
		@b.element(:css => '[ng-model="table.search"]').send_keys(@searchstring)
		@b.element(:css => '[ng-model="table.search"]').send_keys(:enter)
		sleep 2
		@b.element(:css => '[ng-click="selectAll()"').click()
		@b.button(:text => 'Save Resources').when_enabled.click()
	end

end