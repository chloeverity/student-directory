require 'CSV'

@students = [] # an empty array accessible to all methods

def border
  puts "--------------------------------".center(75)
end

def buffer
  3.times do
    puts ""
  end
end

def print_menu
  puts "1. Input the students".center(75)
  puts "2. Show the students".center(75)
  puts "3. Save the list to students.csv".center(75)
  puts "4. Load the list from students.csv".center(75)
  puts "5. Load the students by cohort".center(75)
  puts "9. Exit".center(75) # 9 because we'll be adding more items
end

def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

def process(selection)
  case selection
  when "1"
    puts "You chose to input the students.".center(75)
    input_students
  when "2"
    puts "You chose to show the students.".center(75)
    show_students
  when "3"
    puts "You chose to save the students inputted.".center(75)
    puts "Save complete.".center(75)
    save_students
  when "4"
    puts "You chose to load the students".center(75)
    load_students
  when "5"
    puts "You chose to group the students by cohort".center(75)
    group_by_cohort
  when "9"
    puts "You have chosen to exit, goodbye.".center(75)
    exit
  else
    puts "I don't know what you mean, try again".center(75)
  end
end

def input_students
  border
  puts "Please enter the names of the students".center(75)
  puts "To finish, just hit return twice".center(75)
  border
  @name = STDIN.gets.chomp
  puts "Please enter their cohort".center(75)
  @cohort = gets.chomp.to_sym
    if @cohort.empty?
      @cohort = :january
    end
    if @cohort !~ /january|february|march|april|may|june|july|august|september|october|november|december/
      puts "Please enter a valid month".center(75)
      @cohort = gets.chomp.to_sym
    end
  puts "Please enter their country of origin".center(75)
  @country = gets.chomp
  puts "Please enter their age".center(75)
  @age = gets.chomp.to_i
    if @age == 0
      puts "Please enter a valid age".center(75)
      @age = gets.chomp.to_i
    end
  while !@name.empty? do
    # add the student hash to the array
    acquire_students
    puts "Student added\n".center(75)
      if @students.count > 1
      puts "Now we have #{@students.count} students".center(75)
      elsif @students.count == 1
      puts "Now we have #{@students.count} student".center(75)
      end
    # get another name from the user
    @name = STDIN.gets.chomp
    puts "Please enter their cohort".center(75)
    @cohort = gets.chomp.to_sym
    puts "Please enter their country of origin".center(75)
    @country = gets.chomp
    puts "Please enter their age".center(75)
    @age = gets.chomp.to_i
  end
end

def acquire_students
  @students << {name: @name, cohort: @cohort, country: @country, age: @age}
end

def show_students
  print_header
  print_student_list
  print_footer
end

def print_header
  border
  puts "The students of Villains Academy".center(75)
  border
end

def print_student_list
  @students.each do |student|
    puts "#{student[:name]} (#{student[:cohort]} cohort)".center(75)
  end
end

def print_footer
  border
  puts "Overall, we have #{@students.count} great students".center(75)
  border
end

def save_students
  border
  puts "What file would you like to save as?".center(75)
  file_input = gets.chomp
  if file_input == 'students.csv'

    file = CSV.open("students.csv", "w") do |file|
  # iterate over the array of students
      @students.each do |student|
        student_data = [
        student[:name], 
        student[:cohort],
        student[:country],
        student[:age]
        ]
        file << student_data
      end
      border
      puts "Students saved.\n".center(75)
    end
  else 
    border
    puts "File not found".center(75)
    save_students
  end
end

def load_students_ask
  puts "Which file would you like to load?".center(75)
  input = gets.chomp
  if input == 'students.csv'
      load_students
  else
      puts "File not found".center(75)
      load_students_ask
  end
end

def load_students(filename = "students.csv")
  
  CSV.foreach("./students.csv") do |row|
    @name, @cohort, @country, @age = row
    acquire_students
  end
  puts "Students loaded.".center(75)
end
  

def try_load_students
  filename = ARGV.first# first argument from the command line
  if filename.nil? 
    puts "Loading students.csv by default".center(75)
    load_students
  elsif File.exists?(filename) # if it exists
    load_students(filename)
    border
     puts "Loaded #{@students.count} from #{filename}".center(75)
  else # if it doesn't exist
    border
    puts "Sorry, #{filename} doesn't exist. Loading students.csv by default".center(75)
  end
end

def group_by_cohort
  group_by_cohort = {}

  @students.each do |student|
    cohort = student[:cohort]
    name  = student[:name]

    if group_by_cohort[cohort] == nil
      group_by_cohort[cohort] = [name]
    else
      group_by_cohort[cohort].push(name)
    end
  end

  group_by_cohort.each do |cohort, students|
    border
    puts "#{cohort} cohort: ".center(75)
    students.each.with_index(1) do |name, index|
      puts  "#{index}. #{name}".center(75)
    end
  end
end

try_load_students
interactive_menu