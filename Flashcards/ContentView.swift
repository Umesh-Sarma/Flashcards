//
//  ContentView.swift
//  Flashcards
//
//  Created by Umesh Sarma on 12/16/23.
//

import SwiftUI

struct Flashcard: Identifiable {
    var id = UUID()
    var question: String
    var answer: String
}

struct ContentView: View {
    // Properties for managing state and data
    @State private var flashcards: [Flashcard] = []
    @State private var userQuestion: String = ""
    @State private var userAnswer: String = ""

    var body: some View {
        // Main navigation view
        NavigationView {
            VStack {
                // User input for question
                TextField("Type your question here", text: $userQuestion)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 2))
                    .padding(.horizontal)

                // User input for answer
                TextField("Type your answer here", text: $userAnswer)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 2))
                    .padding(.horizontal)

                // Button to create a new flashcard
                Button(action: addFlashcard) {
                    Text("Create Flashcard")
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                }
                .padding(.top, 10)

                // List displaying created flashcards
                List {
                    ForEach(flashcards) { flashcard in
                        HStack {
                            // Displaying flashcard question and answer
                            VStack(alignment: .leading) {
                                Text("Question: \(flashcard.question)")
                                    .padding(.bottom, 4)

                                Text("Answer: \(flashcard.answer)")
                                    .foregroundColor(.gray)
                            }

                            // Button to delete a flashcard
                            Spacer()
                            Button(action: {
                                deleteFlashcard(flashcard)
                            }) {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                                    .padding()
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {}
                        .padding(.vertical, 8)
                    }
                }
                .padding(.horizontal)

                // Navigation link to start the quiz
                NavigationLink(destination: QuizView(flashcards: flashcards)) {
                    Text("Start Quiz")
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.top, 20)
                }
                .padding(.horizontal)
            }
            .padding()

            // Navigation bar settings
            .background(Color(UIColor.systemTeal)) // Background color
            .navigationTitle("FlashCards App") // Title
            .navigationBarItems(trailing:
                // Button to reset the app
                Button(action: resetApp) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .foregroundColor(.blue)
                        .padding()
                }
            )
        }
    }

    // Function to add a new flashcard
    func addFlashcard() {
        guard !userQuestion.isEmpty && !userAnswer.isEmpty else { return }
        let newFlashcard = Flashcard(question: userQuestion, answer: userAnswer)
        flashcards.append(newFlashcard)
        userQuestion = ""
        userAnswer = ""
    }

    // Function to delete a flashcard
    func deleteFlashcard(_ flashcard: Flashcard) {
        withAnimation {
            if let index = flashcards.firstIndex(where: { $0.id == flashcard.id }) {
                flashcards.remove(at: index)
            }
        }
    }

    // Function to reset the app
    func resetApp() {
        withAnimation {
            flashcards.removeAll()
        }
    }
}

// View to display the quiz
struct QuizView: View {
    // Properties for managing quiz state and data
    var flashcards: [Flashcard]
    @State private var isFlippedArray: [Bool]

    // Initializing the view with flashcards data
    init(flashcards: [Flashcard]) {
        self.flashcards = flashcards
        self._isFlippedArray = State(initialValue: Array(repeating: false, count: flashcards.count))
    }

    var body: some View {
        // Scrolling view to display flashcards in a quiz
        ScrollView {
            VStack {
                ForEach(Array(zip(flashcards, isFlippedArray)), id: \.0.id) { flashcard, isFlipped in
                    // Individual quiz card view
                    QuizCardView(flashcard: flashcard, isFlipped: isFlipped) { flipped in
                        if let index = flashcards.firstIndex(where: { $0.id == flashcard.id }) {
                            isFlippedArray[index] = flipped
                        }
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue))
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                }
            }
        }
        .background(Color(UIColor.systemTeal)) // Background color
        .navigationBarItems(trailing:
            // Button to reset the quiz
            Button(action: resetQuiz) {
                Image(systemName: "arrow.counterclockwise.circle.fill")
                    .foregroundColor(.blue)
                    .padding()
            }
        )
        .navigationTitle("Quiz") // Title
    }

    // Function to reset the quiz
    func resetQuiz() {
        withAnimation {
            isFlippedArray = Array(repeating: false, count: flashcards.count)
        }
    }
}

// View to display an individual quiz card
struct QuizCardView: View {
    // Properties for managing quiz card state and data
    let flashcard: Flashcard
    let isFlipped: Bool
    let onFlip: (Bool) -> Void

    var body: some View {
        // Displaying quiz card content
        VStack {
            if isFlipped {
                // Flipped state showing the answer
                ScrollView {
                    Text("Answer: \(flashcard.answer)")
                        .padding()
                        .rotation3DEffect(
                            .degrees(180),
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                }
            } else {
                // Unflipped state showing the question
                ScrollView {
                    Text("Question: \(flashcard.question)")
                        .padding()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue))
        .foregroundColor(.white)
        .cornerRadius(8)
        .onTapGesture {
            // Handling tap to flip the card
            withAnimation {
                self.onFlip(!self.isFlipped)
            }
        }
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
    }
}

// Preview for the main content view
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



