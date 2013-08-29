require 'mysql'
require 'csv'

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

class Authors
@@authorHash= Hash.new
@@authorArray= Array.new
temp=[]
$db= Mysql.connect('localhost','root','password','test')

# authors would be Serialized array of unique_ids from author table
query=$db.query("SELECT * FROM authors")
query.each_hash do |h|
@@authorHash = h

#validation on authors
temp= @@authorHash['name'].scan(/[^a-zA-Z0-9]/)
raise InvalidAuthorName, "Enter valid author name" if @@authorHash['name']== "" && temp.count !=0 
@@authorArray << @@authorHash				
end
end
class Book < Authors

a=%Q{}
hash= Hash.new
array=Array.new
reader = CSV.open("Books.csv", "r")
header = reader.shift
reader.each do |row|

a = [row]*","      #converts array to string
a = a.split("\t")   #splits string based on '\t'

#converting array to hash
hash=Hash[*("name,price,stock,authors".split(',').zip(a).flatten)]
p hash

#validation of name
raise NoNameError, "No name Entered" if hash['name'].empty? 
temp=[]
temp= hash["name"].scan(/[^a-zA-Z0-9 ]/)       			
raise InvalidName, "Enter a valid name" if (temp.count !=0)

#validation of price
raise NoPrice, "No price Entered" if hash['price']== ''   	 

#validation of stock
if hash['stock']== ""
hash['stock'] = 0
end
temp= hash["stock"].to_s.scan(/\D/)
raise InvalidStock, "Enter valid stock" if temp.count !=0

#validation on authors
temp= hash["authors"].scan(/[^a-zA-Z0-9]/)
raise InvalidAuthorName, "Enter valid author name" if hash["authors"]== "" && temp.count !=0 
string=%W{}

#matching author names with that in author table
 hash["authors"].gsub(/\s/,'').split(",").each{|element| 
array =@@authorArray.select {|f| f["name"].gsub(/\s/,'').eql?(element) }
array=array.reduce Hash.new, :merge
string << array["unique_id"]                           
str= string.join(",")
p str

#inserting values into database
query=$db.query("INSERT INTO books(name,price,stock,authors) VALUES('#{hash['name']}',#{hash['price']},#{hash['stock']},'#{str}')")
}

end
$db.close
end


