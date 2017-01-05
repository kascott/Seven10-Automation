class Filters

	def destinationClean(path1,path2,path3)
		@path1 = path1
		@path2 = path2
		@path3 = path3
		system(@path1 + ' > ' + @path2)
		file_name = @path2
		contentsArray = []
		contentsArray = File.foreach(file_name).map { |line| line.split(' ') }
		if contentsArray.size > 0
			puts('Destintion folder is NOT empty.')
			puts('Removing all folders and folders...')
			system(@path3)
			puts('All folders and files have been deleted.')
			puts('Resuming automated test...')
		else
			puts('Destintion folder is empty.')
			puts('Resuming automated test...')
		end
	end

	def sourceCheck(path1,path2,type,path3,path4)
		@path1 = path1
		@path2 = path2
		@type = type
		@path3 = path3
		@path4 = path4
		system(@path1 + ' > ' + @path2)
		file_name1 = @path2
		contentsArray1 = []
		contentsArray1 = File.foreach(file_name1).map { |line| line.split(' ') }
		puts('Number of folders and files on source = ' + contentsArray1.size.to_s)
		puts('Filter under test = ' + @type)
		puts('Verify that filter condition exists on source...')
		system(@path3 + ' > ' + @path4)
		file_name2 = @path4
		contentsArray2 = []
		contentsArray2 = File.foreach(file_name2).map { |line| line.split(' ') }
		if contentsArray2.size > 0
			puts('Test Conditon met - Source contains ' + contentsArray2.size.to_s + ' that match ' + @type)
			puts('Resuming automated test...')
		else
			puts('Test Conditon NOT met - INVALID TEST.')
		end
	end

	def destinationCheckExclude(path1,path2,type,path3,path4)
		@path1 = path1
		@path2 = path2
		@type = type
		@path3 = path3
		@path4 = path4
		system(@path1 + ' > ' + @path2)
		file_name1 = @path2
		contentsArray1 = []
		contentsArray1 = File.foreach(file_name1).map { |line| line.split(' ') }
		puts('Number of folders and files on destination = ' + contentsArray1.size.to_s)
		puts('Filter under test = ' + @type)
		puts('Verify that filter condition does NOT exists on destination...')
		system(@path3 + ' > ' + @path4)
		file_name2 = @path4
		contentsArray2 = []
		contentsArray2 = File.foreach(file_name2).map { |line| line.split(' ') }
		if contentsArray2.size == 0
			puts('Test Conditon met - Destination contains ' + contentsArray2.size.to_s + ' that match ' + @type)
			puts('Resuming automated test...')
		else
			puts('Test Conditon NOT met - FAILURE.')
		end
	end

	def destinationCheckInclude(path1D,path2D,typeD,path3D,path4D)
		@path1D = path1D
		@path2D = path2D
		@typeD = typeD
		@path3D = path3D
		@path4D = path4D
		system(@path1D + ' > ' + @path2D)
		file_name1D = @path2D
		contentsArray1D = []
		contentsArray1D = File.foreach(file_name1D).map { |line| line.split(' ') }
		puts('Number of folders and files on destination = ' + contentsArray1D.size.to_s)
		puts('Filter under test = ' + @typeD)
		puts('Verify that filter condition does exists on destination...')
		system(@path3D + ' > ' + @path4D)
		file_name2D = @path4D
		contentsArray2D = []
		contentsArray2D = File.foreach(file_name2D).map { |line| line.split(' ') }
		if contentsArray2D.size > 0
			puts('Test Conditon met - Destination contains ' + contentsArray2D.size.to_s + ' that match ' + @typeD)
			puts('Resuming automated test...')
		else
			puts('Test Conditon NOT met - FAILURE.')
		end
	end

	def filterName(browser,filterName,filterDesc)
		@b = browser
		@name = filterName
		@desc = filterDesc
		Watir::Wait.until { @b.text.include? 'Clone' }
		if @b.text.include? 'No Filters have been created'
			@b.button(:css => '[ng-click="createFilter()"]').click()
		else
			@b.button(:css => '[ng-click="createFilter()"]',:index => 1).click()
		end
		Watir::Wait.until { @b.text.include? 'Exclude Files with Attributes:' }
		@b.text_field(:name => 'name').set(@name)
		@b.text_field(:name => 'description').set(@desc)
	end

	def filterExclude(browser,filterEx)
		@b = browser
		@exclude = filterEx
		@b.text_field(:name => 'excludes').set(@exclude)
	end

	def filterInclude(browser,filterEx)
		@b = browser
		@include = filterEx
		@b.text_field(:name => 'includes').set(@include)
	end

	def filterMinSize(browser,filterEx)
		@b = browser
		@minsize = filterEx
		@b.text_field(:css => '[ng-model="bytes"]').set(@minsize)
	end

	def filterMaxSize(browser,filterEx)
		@b = browser
		@maxsize= filterEx
		@b.text_field(:css => '[ng-model="bytes"]',:index => 1).set(@maxsize)
	end

	def filterCreate(browser)
		@b = browser
		@b.button(:text => 'Create').click()
	end

end
