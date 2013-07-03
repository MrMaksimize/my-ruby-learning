require 'jumpstart_auth'

class MicroBlogger
    attr_reader :client

    def initialize
        puts "Init."
        @client = JumpstartAuth.twitter
    end
    
    def tweet(message)
        if message.length > 140
            puts "Message too loong, unable to tweet"
        else
            @client.update(message)
        end
    end

    def dm(target, message)
        puts "Sending #{target} the following message:"
        puts message
        if verify_dm_target(target)
            dm_command = "d @#{target} #{message}"
            self.tweet(dm_command)
        else
            puts "#{target} does not want to hear your bullshit"
        end
    end

    def verify_dm_target(target)
        screen_names = @client.followers.collect{|follower| follower.screen_name}
        if screen_names.include?target
            return true
        else
            return false
        end
    end

    def run
        puts "Welcome to the Twitter Client."
        command = ""
        while command != "q"
            printf "enter command: "
            input = gets.chomp
            parts = input.split
            command = parts[0]
            case command
            when 'q' then puts "See ya!"
            when 't' then self.tweet(parts[1..-1].join(" "))
            when 'dm' then
                dm(parts[1], parts[2..-1].join(" "))
            else
                puts "Hey WTF is #{command}"
            end
        end
    end

end

blogger = MicroBlogger.new
blogger.run

