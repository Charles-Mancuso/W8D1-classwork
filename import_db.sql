PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname VARCHAR(255) NOT NULL,
    lname VARCHAR(255) NOT NULL
);

INSERT INTO
    users (fname, lname)
VALUES
    ('Charles', 'Mancuso'), 
    ('Walter', 'White'), 
    ('Jesse', 'Pinkman'),
    ('Kenai', 'Winston');

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    body VARCHAR(255) NOT NULL,
    associated_author_id INTEGER NOT NULL,

    FOREIGN KEY (associated_author_id) REFERENCES users(id)
);

INSERT INTO
    questions (title, body, associated_author_id)
VALUES
    ('Charles''s question', 'How old are you?', (SELECT id FROM users WHERE fname = 'Charles' AND lname = 'Mancuso')),
    ('Walter''s question', 'How tall are you?', (SELECT id FROM users WHERE fname = 'Walter' AND lname = 'White')),
    ('Jesse''s question', 'What is your favorite food?', (SELECT id FROM users WHERE fname = 'Jesse' AND lname = 'Pinkman')),
    ('Kenai''s question', 'Can I have a treat?', (SELECT id FROM users WHERE fname = 'Kenai' AND lname = 'Winston'));

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
    question_follows (user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE fname = 'Charles' AND lname = 'Mancuso'), (SELECT id FROM questions WHERE title = 'Walter''s question')),
    ((SELECT id FROM users WHERE fname = 'Walter' AND lname = 'White'), (SELECT id FROM questions WHERE title = 'Jesse''s question')),
    ((SELECT id FROM users WHERE fname = 'Jesse' AND lname = 'Pinkman'), (SELECT id FROM questions WHERE title = 'Kenai''s question')),
    ((SELECT id FROM users WHERE fname = 'Kenai' AND lname = 'Winston'), (SELECT id FROM questions WHERE title = 'Charles''s question'));

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    reply_id INTEGER,
    user_id INTEGER NOT NULL,
    body VARCHAR(255) NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (reply_id) REFERENCES replies(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
    replies (question_id, reply_id, user_id, body)
VALUES
    ((SELECT id FROM questions WHERE title = 'Charles''s question'), NULL, 
    (SELECT id FROM users WHERE fname = 'Walter' AND lname = 'White'), 'I''m 42 years old'),
    ((SELECT id FROM questions WHERE title = 'Charles''s question'), (SELECT id FROM replies WHERE body = 'I''m 42 years old'), 
    (SELECT id FROM users WHERE fname = 'Jesse' AND lname = 'Pinkman'), 'You look like you''re 82 years old'),
    ((SELECT id FROM questions WHERE title = 'Jesse''s question'), NULL, 
    (SELECT id FROM users WHERE fname = 'Kenai' AND lname = 'Winston'), 'I like ALL types of food!!!!'),
    ((SELECT id FROM questions WHERE title = 'Jesse''s question'), (SELECT id FROM replies WHERE body = 'I like ALL types of food!!!!'), 
    (SELECT id FROM users WHERE fname = 'Charles' AND lname = 'Mancuso'), 'That''s why you''re so fat');

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Charles' AND lname = 'Mancuso'), (SELECT id FROM questions WHERE title = 'Walter''s question')),
  ((SELECT id FROM users WHERE fname = 'Walter' AND lname = 'White'), (SELECT id FROM questions WHERE title = 'Jesse''s question')),
  ((SELECT id FROM users WHERE fname = 'Jesse' AND lname = 'Pinkman'), (SELECT id FROM questions WHERE title = 'Kenai''s question')),
  ((SELECT id FROM users WHERE fname = 'Kenai' AND lname = 'Winston'), (SELECT id FROM questions WHERE title = 'Charles''s question'));


