# File for taking values from authors table
require 'mysql'

module Authors

class Author
	attr_accessor :authorArray, :temp
	@authorHash= Hash.new
	@authorArray= Array.new

	$db= Mysql.connect('localhost','root','password','test')
		def initialize
		@authorArray= []
		# authors would be Serialized array of unique_ids from author table
		query=$db.query("SELECT * FROM authors")
			query.each_hash do |h|
			@authorHash = h
			
			#validation on authors
			@temp= @authorHash['name'].scan(/[^a-zA-Z0-9]/)
			raise InvalidAuthorName, "Enter valid author name" if @authorHash['name']== "" && temp.count !=0 
			@authorArray << @authorHash
			@authorArray
			end
		end
	end
end



