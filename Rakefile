require "./lib/event_manager.rb"

task :generate_form_letters do 
    contents = get_contents
    template = get_template
    generate_form_letters(contents, template)
end

task :time_target_hours do
    contents = get_contents
    reg_by_hour = get_registrations_by_hour(contents)
    puts reg_by_hour
end

task :time_target_days do
    contents = get_contents
    reg_by_day = get_registrations_by_day(contents)
    puts reg_by_day
end
