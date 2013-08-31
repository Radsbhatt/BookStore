require 'mysql'
require 'csv'
require_relative 'Author'
require_relative 'Accept'

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

	
#class for inserting data into Book table
	class Book 
		include Authors, Accept_module
		def initial
		$obj1= Authors::Author.new
		$obj2= Accept_module::Accept.new
		a=%Q{}
		hash= Hash.new
		array= Array.new
		authorHash= Hash.new
		bookHash= Hash.new
		end
	 	
		
		def array_to_hash
		
			$obj2.reader.each do |row|	
			p row
			a = [row]*","      #converts array to string
			a = a.split("\t")   #splits string based on '\t'
			
			#converting array to hash
			hash=Hash[*("name,price,stock,authors".split(',').zip(a).flatten)]
			Book.new.validation_of_name(hash) 
			end
			##Book.new.display		
		end
		#validation of name
		def validation_of_name(hash1)
		hash = hash1
		
		raise NoNameError, "No name Entered" if hash['name'].empty?   rescue return
	
		$obj1.temp=[]
		$obj1.temp= hash["name"].scan(/[^a-zA-Z0-9 ]/)       			
		raise InvalidName, "Enter a valid name" if ($obj1.temp.count !=0)
		Book.new.validation_of_price(hash)		
		end
		
		#validation of price
		def validation_of_price(hash1)
		hash= hash1
		$obj1.temp= hash['price'].scan(/[^0-9.]/)
		raise NoPrice, "No price Entered" if hash['price']== '' || $obj1.temp.count !=0	 rescue return 
		Book.new.validation_of_stock(hash)		
		end
		
		#validation of stock
		def validation_of_stock(hash1)
		hash = hash1
			if hash['stock']== ""
			hash['stock'] = 0
			end
		$obj1.temp= hash["stock"].to_s.scan(/\D/)
		raise InvalidStock, "Enter valid stock" if $obj1.temp.count !=0 rescue return 
		Book.new.validation_of_author(hash)
		end
		
		#validation on authors
		def validation_of_author(hash1)
		hash = hash1
		$obj1.temp= hash["authors"].scan(/[^a-zA-Z ,]/)
		raise InvalidAuthorName, "Enter valid author name" if hash["authors"]== "" || $obj1.temp.count !=0  rescue return
				
		Book.new.insert(hash)		
		end
		
		#matching author names with that in author table & insert in database
		def insert(hash1)
		hash = hash1		
		string=%W{}
		hash['authors']
		$db.query("INSERT INTO books1(name,price,stock,authors) VALUES('#{hash['name']}',#{hash['price']},#{hash['stock']},'#{hash['authors']}')")   
			
		end
		
		#Displaying records
		def display		
				
		qry=$db.query("SELECT * FROM books1")
		 n_rows = qry.num_rows
			n_rows.times do
	        	puts qry.fetch_row.join("\t")
	    		end		
		
		end	
		
		#searching records by book name		
		def search_by_name
		puts "Enter book name:"
		name = String.new
		name= gets().chomp

		qry=$db.query("SELECT * FROM books1 WHERE name LIKE '#{name}%' ")
 
			qry.each_hash do |h|
			p h
			end
		
		end	

		#searching records by author name		
		def search_by_author
		authorHash2=""
		puts "Enter book author:"
		name = String.new
		name= gets().chomp

		qry=$db.query("SELECT unique_id FROM authors WHERE name='#{name}' ")
 		q=$db.query("SELECT * FROM id")
			q.each_hash do |h1|
			array = h1['author_id'].split(",")
			array
				qry.each_hash do |h|
							
				authorHash2 =h['unique_id']
				
				
				end
								
				var= h1['unique_id'].to_i
				  if array.include?("#{authorHash2}")
					qry2= $db.query("SELECT * FROM books1 WHERE unique_id = #{var}")					
					
						qry2.each_hash do |h2|
						p h2
						end
				end
				
			
				
			end
		end	
		
		#displaying the main menu
		def displayMenu
		puts "Select any one of the options below:"
		puts 
		puts "1. Display"
		puts "2. Search by book name"
		puts "3. Search by author name"
		puts "4. Exit"
		a= gets.to_i 	
		
			until a==4					
			case a
		
			when 1
			Book.new.display

			when 2
			Book.new.search_by_name
			
			when 3
			Book.new.search_by_author
			
			else 
			puts "You entered wrong value!"
			end
			a= gets.to_i
		end
		end
	end

book = Book.new
book.initial
book.displayMenu
##book.array_to_hash


