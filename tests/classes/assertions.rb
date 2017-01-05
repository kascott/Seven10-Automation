def assert message, &block
    begin
        if (block.call)
            puts "Assertion PASSED for #{message}"
        else
            puts "Assertion FAILED for #{message}"
        end
    rescue => e
        puts "Assertion FAILED for #{message} with exception '#{e}'"
    end
end
