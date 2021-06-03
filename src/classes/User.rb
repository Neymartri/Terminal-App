class User 
    @@user_list = []
    attr_reader :id
    attr_accessor :name, :email, :number 

    def initialize(id, name, email, number)
        @id = id
        @name = name
        @email = email
        @number = number

        # New user to user_list method  
        @@user_list.push(self)
    end 

    # access list method & sorted list of user IDS method
    def self.get_list
        return @user_list
    end  

    def self.get_ids
         id_list = []
            @@user_list.each do |user| 
            id_list.push(user.id)
        return id_list.sort
            end
    end

    # Sort list of user name and validate user input for id & return id method  
    def self.get_names
        name_list = []
        @@user_list.each {|user|
            name_list.push(user.name)
        }
        return name_list.sorted
    end

    def self.input_valid_id
        id = "default"
        while !self.get_ids.include? id
            print "Enter a User ID: "
            id = gets.chomp
            if !self.get_ids.include? id
                puts " !! Unable to find User ID !!".colorize(:salmon)
            end 
        end   
        return id 
    end  

    # Validate user input for name and return name method  
    def self.input_valid_name
        name =""
        while !self.get_names.include? name
            print "Enter a name: "
            name =gets.chomp
            if !self.get_names.include? name
                puts "!! Unable to find User !!".colorize(:salmon)
            end 
        end 
        return name
    end   

    # Create the next user ID and Add 1 to the last number of ID method 
    def self.generate_next_id
        next_number = self.get_ids.last.delete("U").to_i + 1 

        new_id = "U" +next_number.to_s
        while new_id.length < 4 
            new_id =insert(1, "0")
        end 
        return new_id
    end 

    # return a user using user ID method 
    def self.get_user_by_id(id)
        index = @@user_list.find_index {| user| 
            user.id == id}
        return @@user_list[index]
    end 

    # return a user using user name method 
    def self.get_user_by_name(name)
        index = @@user_list.find_index {| user| 
        user.name == name}
        return @@user_list[index]
    end 

    # return a sorted user list by name method
    def self.get_sorted_list_by_name
        sort_list = []
        self.gets_names.each {|name| 
            sorted_list.push(self.get_user_by_name(name))
    }
        return sorted_list
    end

    # return a sorted user list by id method   
    def self.get_sorted_list_by_id
        sorted_list =[]
        self.get_ids.each {|id| 
            sorted_list.push(self.get_profile_by_id(id))
        }
        return sorted_list
    end 

    # Method to edit user w/ element + value 
    def edit_user(element, value)
        case element
        when "name" 
            @name = value
        when "email"
            @email = value
        when "number"
            @number = value
        end  
    end   

    # print out table of user sorted by banes method then create array rows of data 
    def self.print_table_by_name
        rows =[]

        self.get_sorted_list_by_name.each {|user|
            rows.push([
                user.id, 
                user.name, 
                user.email, 
                user.number, 
                ]
            )
        }
        # Create table via Terminal-table  
        table = Terminal::Table.new :title => "User List".colorize(:light_blue), :headings => ["User ID".colorize(:light_blue), "Name".colorize(:light_blue), "Email".colorize(:light_blue), "Number".colorize(:light_blue)], :rows => rows
        puts table
    end 

    # print out a table of user sorted by ids method + empty array of data row  
    def self.print_table_by_id 
        rows = []

        self.get_sorted_list_by_id.each {|user|
            rows.push([
                user.id,
                user.name,
                user.email,
                user.number,
                ]
            )
         }

        #  Create terminal-table's table 
        table = Terminal::Table.new :title => "User List".colorize(:light_blue), :headings => ["User ID".colorize(:light_blue), "Name".colorize(:light_blue), "Email".colorize(light_blue), "Number".colorize(:light_blue)], :rows => rows
        puts table
    end 

    # Save to csv file method   
    def self.save_to_csv
        CSV.open("./data/user_list.csv", "w") {|csv| 
            @@user_list.each {|user| 
                csv << [user.id, user.name, user.email, user.number]
            }
         }
     end
end