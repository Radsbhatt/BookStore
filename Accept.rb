#class for accepting values from csv file
module Accept_module	
class Accept 
	attr_accessor :reader
		def initialize
		
		
		@reader = CSV.open("Books.csv", "r")
		header = @reader.shift
		end
	end
end
