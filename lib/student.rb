require_relative "../config/environment.rb"
require 'pry'

class Student
  
    attr_accessor :name, :grade, :id 

    def initialize(name,grade, id=nil)
      @name = name 
      @grade = grade 
    end 

    def self.create_table 
      sql = "CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
        )"
      DB[:conn].execute(sql)
    end 

    def self.drop_table
      sql = "DROP TABLE students"
      DB[:conn].execute(sql)
    end 
    
    def save 
      if self.id 
        self.update
      end 
        sql = "INSERT INTO students (name,grade) VALUES (?,?)"
        DB[:conn].execute(sql,self.name,self.grade)
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end 

    def update 
      sql = "UPDATE students SET name = ?, grade= ? WHERE id= ?"
      DB[:conn].execute(sql,self.name,self.grade,self.id)
    end 
    
    def self.create(name, grade)
      student = Student.new(name,grade)
      student.save
    end 
    
    def self.new_from_db(row)
      new_student = Student.new(:name, :grade, :id) 
      new_student.id = row[0]
      new_student.name = row[1]
      new_student.grade = row[2]
      new_student
    end 
    
    def self.find_by_name(name)
      sql = "SELECT * FROM students WHERE name = ? LIMIT 1"
      DB[:conn].execute(sql,name).map do |row|
        self.new_from_db(row)
      end.first  
    end
end
