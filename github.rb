require 'net/http'
require 'net/https'
require 'json'
require 'date'
require 'openssl'
require 'csv'
module Github_methods
  #this function is used to request the github and getting responce into the data variable
  class Module_class 
    def request_url(url)
      begin 
        /(HTTPS:\/\/api.github.com\/[A-Za-z0-9]+\/\w*\d*)/i =~ url || raise("Url not match")# used to Url check if url not match it gives exception
        uri = URI.parse(url) #parse into the url format
        http = Net::HTTP.new(uri.host, uri.port)
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE #used for open ssl verify none
        http.use_ssl = true
        response = http.get(uri.path) #getting the http responce
        data = JSON.parse(response.body) #retrive the responce into the json format
      rescue Exception => e
        puts "Error occured #{e}"
      end
    end
    # This function used to add the data into the hash it passes hash and the key
    #if key allready present then increment the key value
    #if key not prasent then add key into hash and set key value to 1
    def hash_data_add(hash, key)
      if hash.has_key?(key)
        hash[key] = hash[key] + 1
      else 
        hash[key] = 1
      end
    end
  end
end
class Github
  #include module into Github class
  include(Github_methods)
  def initialize(url_user)    
    @module_class = Module_class.new
    @@data = @module_class.request_url(url_user)
    data_operation
  end
  def data_operation
    hash_name = {} #define hash_name hash
    hash_date = {} #define hash_date hash
    if !@@data.empty?
      @@data.each_index do |i|
        @module_class.hash_data_add(hash_name, @@data[i]['commit']['author']['name'])
        @module_class.hash_data_add(hash_date, Date.strptime(@@data[i]['commit']['author']['date'], '%Y-%m-%d'))
      end
      #Display the hash in console and writing csv file
      CSV.open("file.csv", "wb") do |csv|
        csv << ["another", "row"]
        hash_name.each do
          |key,value| puts "#{key} #{value}"
          csv << ["#{key}", "#{value}",]
        end
        hash_date.each do
          |key,value| puts "#{key} #{value}"
          csv << ["#{key}", "#{value}",]
        end
      end
    end
  end
end
