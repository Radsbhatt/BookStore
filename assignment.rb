require 'mysql'
require 'csv'
require_relative 'Author'

class InvalidAuthorName < RuntimeError
end
class NoNameError < RuntimeError
end
class InvalidName < RuntimeError
end
class NoPrice < RuntimeError
end
class InvalidStock < RuntimeError
end

	#class for accepting values from csv file
	class Accept 
	attr_accessor :reader
		def initialize
		a=%Q{}
		hash= Hash.new
		array=Array.new
		@reader = CSV.open("Books.csv", "r")
		header = @reader.shift
		end
	end

	#class for inserting data into Book table
	class Book < Accept
		include Authors
	obj1= Authors::Author.new
	obj2= Accept.new
		obj2.reader.each do |row|

		a = [row]*","      #converts array to string
		a = a.split("\t")   #splits string based on '\t'

		#converting array to hash
		hash=Hash[*("name,price,stock,authors".split(',').zip(a).flatten)]
		p hash

		#validation of name
		raise NoNameError, "No name Entered" if hash['name'].empty? 
		obj1.temp=[]
		obj1.temp= hash["name"].scan(/[^a-zA-Z0-9 ]/)       			
		raise InvalidName, "Enter a valid name" if (obj1.temp.count !=0)

		#validation of price
		obj1.temp= hash['price'].scan(/[^0-9 ]/)
		raise NoPrice, "No price Entered" if hash['price']== '' && obj1.temp.count !=0	 

		#validation of stock
			if hash['stock']== ""
			hash['stock'] = 0
			end
		obj1.temp= hash["stock"].to_s.scan(/\D/)
		raise InvalidStock, "Enter valid stock" if obj1.temp.count !=0

		#validation on authors
		obj1.temp= hash["authors"].scan(/[^a-zA-Z0-9]/)
		raise InvalidAuthorName, "Enter valid author name" if hash["authors"]== "" && obj1.temp.count !=0 
		string=%W{}

		#matching author names with that in author table
		hash["authors"].gsub(/\s/,'').split(",").each {|element| 
		array =obj1.authorArray.select {|f| f["name"].gsub(/\s/,'').eql?(element) }
		array=array.reduce Hash.new, :merge
		string << array["unique_id"]                           
		str= string.join(",")

		#inserting values into database
		query=$db.query("INSERT INTO books(name,price,stock,authors) VALUES('#{hash['name']}',#{hash['price']},#{hash['stock']},'#{str}')")
		}

		end
		$db.close
	end


