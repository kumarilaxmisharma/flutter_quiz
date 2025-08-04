import 'package:flutter_final/data/QuestionQuiz.dart';

List<Map<String, dynamic>> rawQuestions = [
  {
    "question": "Which ocean is the deepest in the world? (Q1)",
    "options": ["Atlantic", "Indian", "Pacific", "Arctic"],
    "answer": "Pacific",
  },
  {
    "question": "Who painted the Mona Lisa? (Q2)",
    "options": [
      "Vincent van Gogh",
      "Pablo Picasso",
      "Leonardo da Vinci",
      "Michelangelo",
    ],
    "answer": "Leonardo da Vinci",
  },
  {
    "question": "Who discovered gravity after seeing an apple fall? (Q3)",
    "options": [
      "Albert Einstein",
      "Isaac Newton",
      "Galileo Galilei",
      "Nikola Tesla",
    ],
    "answer": "Isaac Newton",
  },
  {
    "question": "Who discovered gravity after seeing an apple fall? (Q4)",
    "options": [
      "Albert Einstein",
      "Isaac Newton",
      "Galileo Galilei",
      "Nikola Tesla",
    ],
    "answer": "Isaac Newton",
  },
  {
    "question": "Who wrote Romeo and Juliet? (Q5)",
    "options": [
      "William Shakespeare",
      "Charles Dickens",
      "Mark Twain",
      "Jane Austen",
    ],
    "answer": "William Shakespeare",
  },
  {
    "question": "In which year did the Titanic sink? (Q6)",
    "options": ["1905", "1912", "1920", "1898"],
    "answer": "1912",
  },
  {
    "question": "What is the hardest natural substance on Earth? (Q7)",
    "options": ["Diamond", "Gold", "Iron", "Quartz"],
    "answer": "Diamond",
  },
  {
    "question": "Who wrote Romeo and Juliet? (Q8)",
    "options": [
      "William Shakespeare",
      "Charles Dickens",
      "Mark Twain",
      "Jane Austen",
    ],
    "answer": "William Shakespeare",
  },
  {
    "question":
        "Which language has the most native speakers in the world? (Q9)",
    "options": ["English", "Mandarin Chinese", "Spanish", "Hindi"],
    "answer": "Mandarin Chinese",
  },
  {
    "question": "What is the largest planet in our solar system? (Q10)",
    "options": ["Earth", "Jupiter", "Saturn", "Mars"],
    "answer": "Jupiter",
  },
  {
    "question": "Who painted the Mona Lisa? (Q11)",
    "options": [
      "Vincent van Gogh",
      "Pablo Picasso",
      "Leonardo da Vinci",
      "Michelangelo",
    ],
    "answer": "Leonardo da Vinci",
  },
  {
    "question": "Which ocean is the deepest in the world? (Q12)",
    "options": ["Atlantic", "Indian", "Pacific", "Arctic"],
    "answer": "Pacific",
  },
  {
    "question": "What is the smallest country in the world? (Q13)",
    "options": ["Vatican City", "Monaco", "Nauru", "San Marino"],
    "answer": "Vatican City",
  },
  {
    "question": "Who discovered gravity after seeing an apple fall? (Q14)",
    "options": [
      "Albert Einstein",
      "Isaac Newton",
      "Galileo Galilei",
      "Nikola Tesla",
    ],
    "answer": "Isaac Newton",
  },
  {
    "question": "What is the capital of Australia? (Q15)",
    "options": ["Sydney", "Melbourne", "Brisbane", "Canberra"],
    "answer": "Canberra",
  },
  {
    "question": "Which gas do plants absorb from the atmosphere? (Q16)",
    "options": ["Oxygen", "Nitrogen", "Carbon dioxide", "Helium"],
    "answer": "Carbon dioxide",
  },
  {
    "question": "What currency is used in Japan? (Q17)",
    "options": ["Won", "Dollar", "Yen", "Yuan"],
    "answer": "Yen",
  },
  {
    "question": "Which country is known as the Land of the Rising Sun? (Q18)",
    "options": ["China", "Japan", "South Korea", "Thailand"],
    "answer": "Japan",
  },
  {
    "question": "What is the largest planet in our solar system? (Q19)",
    "options": ["Earth", "Jupiter", "Saturn", "Mars"],
    "answer": "Jupiter",
  },
  {
    "question": "What is the largest planet in our solar system? (Q20)",
    "options": ["Earth", "Jupiter", "Saturn", "Mars"],
    "answer": "Jupiter",
  },
  {
    "question": "How many bones are in the adult human body? (Q21)",
    "options": ["198", "206", "211", "224"],
    "answer": "206",
  },
  {
    "question": "Who painted the Mona Lisa? (Q22)",
    "options": [
      "Vincent van Gogh",
      "Pablo Picasso",
      "Leonardo da Vinci",
      "Michelangelo",
    ],
    "answer": "Leonardo da Vinci",
  },
  {
    "question": "What is the hardest natural substance on Earth? (Q23)",
    "options": ["Diamond", "Gold", "Iron", "Quartz"],
    "answer": "Diamond",
  },
  {
    "question": "How many bones are in the adult human body? (Q24)",
    "options": ["198", "206", "211", "224"],
    "answer": "206",
  },
  {
    "question": "In which year did the Titanic sink? (Q25)",
    "options": ["1905", "1912", "1920", "1898"],
    "answer": "1912",
  },
  {
    "question": "Who painted the Mona Lisa? (Q26)",
    "options": [
      "Vincent van Gogh",
      "Pablo Picasso",
      "Leonardo da Vinci",
      "Michelangelo",
    ],
    "answer": "Leonardo da Vinci",
  },
  {
    "question": "What is the largest planet in our solar system? (Q27)",
    "options": ["Earth", "Jupiter", "Saturn", "Mars"],
    "answer": "Jupiter",
  },
  {
    "question": "What is the capital of Australia? (Q28)",
    "options": ["Sydney", "Melbourne", "Brisbane", "Canberra"],
    "answer": "Canberra",
  },
  {
    "question": "Which ocean is the deepest in the world? (Q29)",
    "options": ["Atlantic", "Indian", "Pacific", "Arctic"],
    "answer": "Pacific",
  },
  {
    "question": "Which country is known as the Land of the Rising Sun? (Q30)",
    "options": ["China", "Japan", "South Korea", "Thailand"],
    "answer": "Japan",
  },
  {
    "question": "What is the largest planet in our solar system? (Q31)",
    "options": ["Earth", "Jupiter", "Saturn", "Mars"],
    "answer": "Jupiter",
  },
  {
    "question": "What is the capital of Australia? (Q32)",
    "options": ["Sydney", "Melbourne", "Brisbane", "Canberra"],
    "answer": "Canberra",
  },
  {
    "question": "Who wrote Romeo and Juliet? (Q33)",
    "options": [
      "William Shakespeare",
      "Charles Dickens",
      "Mark Twain",
      "Jane Austen",
    ],
    "answer": "William Shakespeare",
  },
  // {
  //   "question": "Which ocean is the deepest in the world? (Q34)",
  //   "options": ["Atlantic", "Indian", "Pacific", "Arctic"],
  //   "answer": "Pacific",
  // },
  // {
  //   "question": "Who wrote Romeo and Juliet? (Q35)",
  //   "options": [
  //     "William Shakespeare",
  //     "Charles Dickens",
  //     "Mark Twain",
  //     "Jane Austen",
  //   ],
  //   "answer": "William Shakespeare",
  // },
  // {
  //   "question": "Which ocean is the deepest in the world? (Q36)",
  //   "options": ["Atlantic", "Indian", "Pacific", "Arctic"],
  //   "answer": "Pacific",
  // },
  // {
  //   "question": "Who discovered gravity after seeing an apple fall? (Q37)",
  //   "options": [
  //     "Albert Einstein",
  //     "Isaac Newton",
  //     "Galileo Galilei",
  //     "Nikola Tesla",
  //   ],
  //   "answer": "Isaac Newton",
  // },
  // {
  //   "question": "What is the largest planet in our solar system? (Q38)",
  //   "options": ["Earth", "Jupiter", "Saturn", "Mars"],
  //   "answer": "Jupiter",
  // },
  // {
  //   "question": "What is the smallest country in the world? (Q39)",
  //   "options": ["Vatican City", "Monaco", "Nauru", "San Marino"],
  //   "answer": "Vatican City",
  // },
  // {
  //   "question": "What is the hardest natural substance on Earth? (Q40)",
  //   "options": ["Diamond", "Gold", "Iron", "Quartz"],
  //   "answer": "Diamond",
  // },
  // {
  //   "question": "What is the smallest country in the world? (Q41)",
  //   "options": ["Vatican City", "Monaco", "Nauru", "San Marino"],
  //   "answer": "Vatican City",
  // },
  // {
  //   "question": "What is the chemical symbol for gold? (Q42)",
  //   "options": ["G", "Au", "Ag", "Go"],
  //   "answer": "Au",
  // },
  // {
  //   "question": "In which year did the Titanic sink? (Q43)",
  //   "options": ["1905", "1912", "1920", "1898"],
  //   "answer": "1912",
  // },
  // {
  //   "question": "Who painted the Mona Lisa? (Q44)",
  //   "options": [
  //     "Vincent van Gogh",
  //     "Pablo Picasso",
  //     "Leonardo da Vinci",
  //     "Michelangelo",
  //   ],
  //   "answer": "Leonardo da Vinci",
  // },
  // {
  //   "question": "What currency is used in Japan? (Q45)",
  //   "options": ["Won", "Dollar", "Yen", "Yuan"],
  //   "answer": "Yen",
  // },
  // {
  //   "question": "Which country is known as the Land of the Rising Sun? (Q46)",
  //   "options": ["China", "Japan", "South Korea", "Thailand"],
  //   "answer": "Japan",
  // },
  // {
  //   "question": "What is the largest planet in our solar system? (Q47)",
  //   "options": ["Earth", "Jupiter", "Saturn", "Mars"],
  //   "answer": "Jupiter",
  // },
  // {
  //   "question": "Which gas do plants absorb from the atmosphere? (Q48)",
  //   "options": ["Oxygen", "Nitrogen", "Carbon dioxide", "Helium"],
  //   "answer": "Carbon dioxide",
  // },
  // {
  //   "question":
  //       "Which language has the most native speakers in the world? (Q49)",
  //   "options": ["English", "Mandarin Chinese", "Spanish", "Hindi"],
  //   "answer": "Mandarin Chinese",
  // },
  // {
  //   "question": "Who discovered gravity after seeing an apple fall? (Q50)",
  //   "options": [
  //     "Albert Einstein",
  //     "Isaac Newton",
  //     "Galileo Galilei",
  //     "Nikola Tesla",
  //   ],
  //   "answer": "Isaac Newton",
  // },
  // {
  //   "question": "Which gas do plants absorb from the atmosphere? (Q51)",
  //   "options": ["Oxygen", "Nitrogen", "Carbon dioxide", "Helium"],
  //   "answer": "Carbon dioxide",
  // },
  // {
  //   "question": "Who wrote Romeo and Juliet? (Q52)",
  //   "options": [
  //     "William Shakespeare",
  //     "Charles Dickens",
  //     "Mark Twain",
  //     "Jane Austen",
  //   ],
  //   "answer": "William Shakespeare",
  // },
  // {
  //   "question": "Which country is known as the Land of the Rising Sun? (Q53)",
  //   "options": ["China", "Japan", "South Korea", "Thailand"],
  //   "answer": "Japan",
  // },
  // {
  //   "question": "What is the smallest country in the world? (Q54)",
  //   "options": ["Vatican City", "Monaco", "Nauru", "San Marino"],
  //   "answer": "Vatican City",
  // },
  // {
  //   "question": "Who painted the Mona Lisa? (Q55)",
  //   "options": [
  //     "Vincent van Gogh",
  //     "Pablo Picasso",
  //     "Leonardo da Vinci",
  //     "Michelangelo",
  //   ],
  //   "answer": "Leonardo da Vinci",
  // },
  // {
  //   "question": "What is the chemical symbol for gold? (Q56)",
  //   "options": ["G", "Au", "Ag", "Go"],
  //   "answer": "Au",
  // },
  // {
  //   "question": "Who wrote Romeo and Juliet? (Q57)",
  //   "options": [
  //     "William Shakespeare",
  //     "Charles Dickens",
  //     "Mark Twain",
  //     "Jane Austen",
  //   ],
  //   "answer": "William Shakespeare",
  // },
  // {
  //   "question": "How many bones are in the adult human body? (Q58)",
  //   "options": ["198", "206", "211", "224"],
  //   "answer": "206",
  // },
  // {
  //   "question": "In which year did the Titanic sink? (Q59)",
  //   "options": ["1905", "1912", "1920", "1898"],
  //   "answer": "1912",
  // },
  // {
  //   "question": "What currency is used in Japan? (Q60)",
  //   "options": ["Won", "Dollar", "Yen", "Yuan"],
  //   "answer": "Yen",
  // },
  // {
  //   "question": "Who discovered gravity after seeing an apple fall? (Q61)",
  //   "options": [
  //     "Albert Einstein",
  //     "Isaac Newton",
  //     "Galileo Galilei",
  //     "Nikola Tesla",
  //   ],
  //   "answer": "Isaac Newton",
  // },
  // {
  //   "question": "Who wrote Romeo and Juliet? (Q62)",
  //   "options": [
  //     "William Shakespeare",
  //     "Charles Dickens",
  //     "Mark Twain",
  //     "Jane Austen",
  //   ],
  //   "answer": "William Shakespeare",
  // },
  // {
  //   "question": "In which year did the Titanic sink? (Q63)",
  //   "options": ["1905", "1912", "1920", "1898"],
  //   "answer": "1912",
  // },
  // {
  //   "question": "What is the hardest natural substance on Earth? (Q64)",
  //   "options": ["Diamond", "Gold", "Iron", "Quartz"],
  //   "answer": "Diamond",
  // },
  // {
  //   "question": "Who painted the Mona Lisa? (Q65)",
  //   "options": [
  //     "Vincent van Gogh",
  //     "Pablo Picasso",
  //     "Leonardo da Vinci",
  //     "Michelangelo",
  //   ],
  //   "answer": "Leonardo da Vinci",
  // },
  // {
  //   "question": "In which year did the Titanic sink? (Q66)",
  //   "options": ["1905", "1912", "1920", "1898"],
  //   "answer": "1912",
  // },
  // {
  //   "question": "Which gas do plants absorb from the atmosphere? (Q67)",
  //   "options": ["Oxygen", "Nitrogen", "Carbon dioxide", "Helium"],
  //   "answer": "Carbon dioxide",
  // },
  // {
  //   "question": "What is the largest planet in our solar system? (Q68)",
  //   "options": ["Earth", "Jupiter", "Saturn", "Mars"],
  //   "answer": "Jupiter",
  // },
  // {
  //   "question": "Who wrote Romeo and Juliet? (Q69)",
  //   "options": [
  //     "William Shakespeare",
  //     "Charles Dickens",
  //     "Mark Twain",
  //     "Jane Austen",
  //   ],
  //   "answer": "William Shakespeare",
  // },
  // {
  //   "question": "Who painted the Mona Lisa? (Q70)",
  //   "options": [
  //     "Vincent van Gogh",
  //     "Pablo Picasso",
  //     "Leonardo da Vinci",
  //     "Michelangelo",
  //   ],
  //   "answer": "Leonardo da Vinci",
  // },
  // {
  //   "question": "What is the largest planet in our solar system? (Q71)",
  //   "options": ["Earth", "Jupiter", "Saturn", "Mars"],
  //   "answer": "Jupiter",
  // },
  // {
  //   "question": "Who wrote Romeo and Juliet? (Q72)",
  //   "options": [
  //     "William Shakespeare",
  //     "Charles Dickens",
  //     "Mark Twain",
  //     "Jane Austen",
  //   ],
  //   "answer": "William Shakespeare",
  // },
  // {
  //   "question": "Who wrote Romeo and Juliet? (Q73)",
  //   "options": [
  //     "William Shakespeare",
  //     "Charles Dickens",
  //     "Mark Twain",
  //     "Jane Austen",
  //   ],
  //   "answer": "William Shakespeare",
  // },
  // {
  //   "question": "Who painted the Mona Lisa? (Q74)",
  //   "options": [
  //     "Vincent van Gogh",
  //     "Pablo Picasso",
  //     "Leonardo da Vinci",
  //     "Michelangelo",
  //   ],
  //   "answer": "Leonardo da Vinci",
  // },
  // {
  //   "question": "What is the capital of Australia? (Q75)",
  //   "options": ["Sydney", "Melbourne", "Brisbane", "Canberra"],
  //   "answer": "Canberra",
  // },
  // {
  //   "question": "What currency is used in Japan? (Q76)",
  //   "options": ["Won", "Dollar", "Yen", "Yuan"],
  //   "answer": "Yen",
  // },
  // {
  //   "question": "What is the chemical symbol for gold? (Q77)",
  //   "options": ["G", "Au", "Ag", "Go"],
  //   "answer": "Au",
  // },
  // {
  //   "question": "How many bones are in the adult human body? (Q78)",
  //   "options": ["198", "206", "211", "224"],
  //   "answer": "206",
  // },
  // {
  //   "question": "What currency is used in Japan? (Q79)",
  //   "options": ["Won", "Dollar", "Yen", "Yuan"],
  //   "answer": "Yen",
  // },
  // {
  //   "question": "Who painted the Mona Lisa? (Q80)",
  //   "options": [
  //     "Vincent van Gogh",
  //     "Pablo Picasso",
  //     "Leonardo da Vinci",
  //     "Michelangelo",
  //   ],
  //   "answer": "Leonardo da Vinci",
  // },
  // {
  //   "question": "Which ocean is the deepest in the world? (Q81)",
  //   "options": ["Atlantic", "Indian", "Pacific", "Arctic"],
  //   "answer": "Pacific",
  // },
  // {
  //   "question": "How many bones are in the adult human body? (Q82)",
  //   "options": ["198", "206", "211", "224"],
  //   "answer": "206",
  // },
  // {
  //   "question": "Who wrote Romeo and Juliet? (Q83)",
  //   "options": [
  //     "William Shakespeare",
  //     "Charles Dickens",
  //     "Mark Twain",
  //     "Jane Austen",
  //   ],
  //   "answer": "William Shakespeare",
  // },
  // {
  //   "question": "Who discovered gravity after seeing an apple fall? (Q84)",
  //   "options": [
  //     "Albert Einstein",
  //     "Isaac Newton",
  //     "Galileo Galilei",
  //     "Nikola Tesla",
  //   ],
  //   "answer": "Isaac Newton",
  // },
  // {
  //   "question": "What is the smallest country in the world? (Q85)",
  //   "options": ["Vatican City", "Monaco", "Nauru", "San Marino"],
  //   "answer": "Vatican City",
  // },
  // {
  //   "question": "Which country is known as the Land of the Rising Sun? (Q86)",
  //   "options": ["China", "Japan", "South Korea", "Thailand"],
  //   "answer": "Japan",
  // },
  // {
  //   "question": "What is the smallest country in the world? (Q87)",
  //   "options": ["Vatican City", "Monaco", "Nauru", "San Marino"],
  //   "answer": "Vatican City",
  // },
  // {
  //   "question": "In which year did the Titanic sink? (Q88)",
  //   "options": ["1905", "1912", "1920", "1898"],
  //   "answer": "1912",
  // },
  // {
  //   "question": "What is the smallest country in the world? (Q89)",
  //   "options": ["Vatican City", "Monaco", "Nauru", "San Marino"],
  //   "answer": "Vatican City",
  // },
  // {
  //   "question": "In which year did the Titanic sink? (Q90)",
  //   "options": ["1905", "1912", "1920", "1898"],
  //   "answer": "1912",
  // },
  // {
  //   "question": "Which country is known as the Land of the Rising Sun? (Q91)",
  //   "options": ["China", "Japan", "South Korea", "Thailand"],
  //   "answer": "Japan",
  // },
  // {
  //   "question": "Which country is known as the Land of the Rising Sun? (Q92)",
  //   "options": ["China", "Japan", "South Korea", "Thailand"],
  //   "answer": "Japan",
  // },
  // {
  //   "question": "What currency is used in Japan? (Q93)",
  //   "options": ["Won", "Dollar", "Yen", "Yuan"],
  //   "answer": "Yen",
  // },
  // {
  //   "question": "Which country is known as the Land of the Rising Sun? (Q94)",
  //   "options": ["China", "Japan", "South Korea", "Thailand"],
  //   "answer": "Japan",
  // },
  // {
  //   "question": "Who discovered gravity after seeing an apple fall? (Q95)",
  //   "options": [
  //     "Albert Einstein",
  //     "Isaac Newton",
  //     "Galileo Galilei",
  //     "Nikola Tesla",
  //   ],
  //   "answer": "Isaac Newton",
  // },
  // {
  //   "question": "What is the smallest country in the world? (Q96)",
  //   "options": ["Vatican City", "Monaco", "Nauru", "San Marino"],
  //   "answer": "Vatican City",
  // },
  // {
  //   "question": "In which year did the Titanic sink? (Q97)",
  //   "options": ["1905", "1912", "1920", "1898"],
  //   "answer": "1912",
  // },
  // {
  //   "question": "Which ocean is the deepest in the world? (Q98)",
  //   "options": ["Atlantic", "Indian", "Pacific", "Arctic"],
  //   "answer": "Pacific",
  // },
  // {
  //   "question": "What currency is used in Japan? (Q99)",
  //   "options": ["Won", "Dollar", "Yen", "Yuan"],
  //   "answer": "Yen",
  // },
  // {
  //   "question": "How many bones are in the adult human body? (Q100)",
  //   "options": ["198", "206", "211", "224"],
  //   "answer": "206",
  // },
];

List<QuestionQuiz> listQuestions =
    rawQuestions.map((q) {
      return QuestionQuiz.fromJson(q);
    }).toList();
