require 'net/http'
require 'net/https'
require "rubygems"
require 'json'
require 'date'
require 'fastercsv'
class Github
  #used to initialise the variable  
  def initialize(url_user )
    @hash_date1
    @hash_name1
    url_request(url_user)
  end
  
  #this function is used for add data into hash table format we will pass the hash table name and value 
  def add_hash_data(hash_temp,value)
    if hash_temp.has_key?(value)
      hash_temp[value] = hash_temp[value] + 1
    else
      hash_temp[value] = 1
    end
    return hash_temp
  end

  def display_hash(hash_temp)
        hash_temp.each {|key, value| puts " #{key} is #{value} \n"}
  end  
  
  #this functio used for send https request to web sites and retrive data into json format
  def url_request(url)

    if check_url(url) then        
      begin
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        
        http.use_ssl = true
        response = http.get(uri.path)
        @data = JSON.parse(response.body)
        retrive_data
      rescue
        p 'Path not found'
      end
    else
      puts 'url not valid'
    end    
  end
  
  #this function is used for retrive data from json format into hash format  (hash_name and hash_date) also write cvs function called
  def retrive_data
    i = 0
    hash_date = Hash.new
    hash_name = Hash.new
    if !@data.empty?
      @data.each do
        author = @data[i]['commit']['author']['name']
        hash_name = add_hash_data(hash_name,author)
        date = Date.parse @data[i]['commit']['author']['date']
        hash_date = add_hash_data(hash_date,date)
        i = i+1
      end
    end
    puts "Total record found #{i}"
    display_hash(hash_name)
    display_hash(hash_date)
    write_csv(hash_name,hash_date,i)
    @hash_date1 = hash_date
    @hash_name1 = hash_name
  end
  
  #this function is used for testing check name and date is in json and return how much commit on the given date by given user name
  def checkName_date(date,name)
    i = 0
    counter = 0
    date1 = Date.parse date
    if !@data.empty?
      @data.each do
        date2 = Date.parse @data[i]['commit']['author']['date']
        if @data[i]['commit']['author']['name'] == name && date2 == date1
          counter = counter + 1          
        end
        i=i+1
      end
    end
    return counter
  end
  
  #this function is used for testing check name and date is in json and return how much commit on the given date
  def getComments_onDate(date)
    date1 = Date.parse date
    begin
      return @hash_date1[date1]
    rescue
      return nil
    end
  end
 
  #this function used for wirting output into cvs file but problem was in cvs<<[""""] divides coloum using space
  def write_csv(hash_name , hash_date , i)
    FasterCSV.open("data.csv", "w") do |csv|
      csv << ["Total_record_found ""#{i}"]
      hash_name.each {
        |key, value| 
        key.gsub(' ','_')
        csv << ["#{key} ""#{value}"]
      }
      hash_date.each {|key, value| csv << ["#{key} ""#{value}"]}
    end
  end

  #this function used for url is valid or not
  def check_url(url)
    url_regex = Regexp.new("((https):((//)api.github.com/repos/)+[\w\d:\#@%/;$()~_?\+-=\\\\.&]*)")
    if url =~ url_regex then
      return true
    else
      return false
    end
  end
end
puts "Enter Github URL  like( https://api.github.com/repos/joshsoftware/khoj/commits )"
a = gets()
gh = Github.new(a)
