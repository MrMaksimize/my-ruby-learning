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
    hours = {}
    contents.each do |row|
        reg_date = row[:regdate].to_s
        hour = DateTime.strptime(reg_date, '%m/%d/%y %H:%M').hour.to_s
        if !hours.has_key?(hour)
            hours[hour] = 1
        else
            hours[hour] = hours[hour] + 1
        end
    end
    #return hours.sort_by { |hour, repeats| repeats }
    max_hash = hours.max_by { |hour, repeats| repeats }
    return "Most registrations occured at #{max_hash[0]}. The registration amount was #{max_hash[1]} times."

end

def get_registrations_by_day(contents)
    days = {}
    contents.each do |row|
        reg_date = row[:regdate].to_s
        day = DateTime.strptime(reg_date, '%m/%d/%y %H:%M').strftime('%A').to_s
        if !days.has_key?(day)
            days[day] = 1
        else
            days[day] = days[day] + 1
        end
    end
    max_hash = days.max_by { |day, repeats| day }
    return "Most registrations occured on #{max_hash[0]}. There were #{max_hash[1]} registrations."
end

