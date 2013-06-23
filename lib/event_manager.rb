require "csv"
puts "EventManager Initialized!"

def clean_zip(zipcode)
    #Convert nil to string, add 0 to beginning, trim to 5
    zipcode.to_s.rjust(5, "0")[0..4]
end

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
contents.each do |row|
    name = row[:first_name]
    zipcode = clean_zip(row[:zipcode])
    puts "#{name} #{zipcode}"
end