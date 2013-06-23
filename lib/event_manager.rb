require "csv"
require "sunlight/congress"
require "erb"
require "date"

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zip(zipcode)
    #Convert nil to string, add 0 to beginning, trim to 5
    zipcode.to_s.rjust(5, "0")[0..4]
end

def clean_phone(phone_number)
    #puts "original #{phone_number}"
    phone_number = phone_number.to_s.gsub(/[\(\)\-\s\.\+\D]*/,'')
    #puts "precheck #{phone_number}"
    if phone_number.length == 10
        return phone_number
    elsif phone_number.length == 11 && phone_number[0] == "1"
        return phone_number[1..10]
    elsif phone_number.length < 10 || phone_number.length >= 11
        return nil
    end
end

def legislators_by_zip(zipcode)
    legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

def save_thank_you_letters(id,form_letter)
    Dir.mkdir("output") unless Dir.exists? "output"

    filename = "output/thanks_#{id}.html"

    File.open(filename,'w') do |file|
        file.puts form_letter
    end
end

def get_contents
    return CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
end

def get_template
    template_letter = File.read "form_letter.erb"
    return ERB.new template_letter
end

def generate_form_letters (contents, erb_template)
    contents.each do |row|
        id = row[0]
        name = row[:first_name]
        zipcode = clean_zip(row[:zipcode])
        legislators = legislators_by_zip(zipcode)
        form_letter = erb_template.result(binding)
        phone_number = clean_phone(row[:homephone])
        save_thank_you_letters(id,form_letter)
    end
end

def get_registrations_by_hour(contents)
    hours = []
    hours = contents.collect do |row|
        reg_date = row[:regdate].to_s
        date_time = DateTime.strptime(reg_date, '%m/%d/%y %H:%M')
        "#{date_time.hour}"
    end
    #HOW?

end

