require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :id, :name, :grade

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = "CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT);"
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students;"
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = "INSERT INTO students(name, grade) VALUES (?, ?);"
      arg = [self.name, self.grade]

      results = DB[:conn].execute(sql, arg)
      check = "SELECT * FROM students;"
      res = DB[:conn].execute(check).flatten
      @id = res.first
    end
  end

  def update
    update = "UPDATE students SET name = '#{self.name}', grade = '#{self.grade}' WHERE id = #{self.id};"
    DB[:conn].execute(update)
  end

  def self.create(name, grade)
    new_student = self.new(name, grade)
    new_student.save
  end

  def self.new_from_db(row)
    new_student = Student.new(row[1], row[2], row[0])
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = '#{name}';"
    res = DB[:conn].execute(sql).flatten
    new_student = Student.new(res[1], res[2])
    new_student.save
    new_student
  end


end
