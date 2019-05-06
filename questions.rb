require 'sqlite3'
require 'singleton'

class QuestionsDBConnection < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class Users
    attr_accessor :fname, :lname
    
    def self.find(id)
        data = QuestionsDatabase.get_first_row(<<-SQL, id: id)
            SELECT
                users.*
            FROM
                users
            WHERE
                users.id = :id
        SQL

        Users.new(data)
    end

    def self.all
        data = QuestionsDBConnection.instance.execute("SELECT * FROM users")
        data.map { |datum| Users.new(datum) }
    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def create
        raise "#{self} already in database" if @id
        QuestionsDBConnection.instance.execute(<<-SQL, @fname, @lname)
            INSERT INTO
                users (fname, lname)
            VALUES
                (?, ?)
        SQL
        @id = QuestionsDBConnection.instance.last_insert_row_id
    end

    def update
        raise "#{self} not in database" unless @id
        QuestionsDBConnection.instance.execute(<<-SQL, @fname, @lname, @id)
            UPDATE
                users
            SET
                fname = ?, lname = ?
            WHERE
                id = ?
        SQL
    end
end

class Questions
    attr_accessor :title, :body, :associated_author_id
    
    def self.find(id)
        data = QuestionsDatabase.get_first_row(<<-SQL, id: id)
            SELECT
                questions.*
            FROM
                questions
            WHERE
                questions.id = :id
        SQL

        Questions.new(data)
    end

    def self.all
        data = QuestionsDBConnection.instance.execute("SELECT * FROM questions")
        data.map { |datum| Questions.new(datum) }
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @associated_author_id = options['associated_author_id']
    end

    def create
        raise "#{self} already in database" if @id
        QuestionsDBConnection.instance.execute(<<-SQL, @title, @body, @associated_author_id)
            INSERT INTO
                questions (title, body, associated_author_id)
            VALUES
                (?, ?, ?)
        SQL
        @id = QuestionsDBConnection.instance.last_insert_row_id
    end

    def update
        raise "#{self} not in database" unless @id
        QuestionsDBConnection.instance.execute(<<-SQL, @title, @body, @associated_author_id, @id)
            UPDATE
                users
            SET
                title = ?, body = ?, associated_author_id = ?
            WHERE
                id = ?
        SQL
    end
end
