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
    @State private var flashcards: [Flashcard] = []
    @State private var userQuestion: String = ""
    @State private var userAnswer: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Type your question here", text: $userQuestion)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Type your answer here", text: $userAnswer)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: addFlashcard) {
                    Text("Create Flashcard")
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                List {
                    ForEach(flashcards) { flashcard in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Question: \(flashcard.question)")
                                    .padding(.bottom, 4)

                                Text("Answer: \(flashcard.answer)")
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            Button(action: {
                                // Show delete confirmation or perform deletion
                                deleteFlashcard(flashcard)
                            }) {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                                    .padding()
                            }
                            .buttonStyle(BorderlessButtonStyle()) // Use BorderlessButtonStyle to avoid highlighting
                        }
                        .contentShape(Rectangle()) // Make the whole row tappable
                        .onTapGesture {} // Empty onTapGesture to avoid triggering row tap
                    }
                }

                NavigationLink(destination: QuizView(flashcards: flashcards)) {
                    Text("Start Quiz")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top, 20)
                }
            }
            .padding()
            .navigationTitle("FlashCards App")
            .navigationBarItems(trailing:
                Button(action: resetApp) {
                    Text("Reset")
                        .foregroundColor(.blue)
                        .padding()
                }
            )
        }
    }

    func addFlashcard() {
        guard !userQuestion.isEmpty && !userAnswer.isEmpty else { return }
        let newFlashcard = Flashcard(question: userQuestion, answer: userAnswer)
        flashcards.append(newFlashcard)
        userQuestion = ""
        userAnswer = ""
    }

    func deleteFlashcard(_ flashcard: Flashcard) {
        withAnimation {
            if let index = flashcards.firstIndex(where: { $0.id == flashcard.id }) {
                flashcards.remove(at: index)
            }
        }
    }

    func resetApp() {
        withAnimation {
            flashcards.removeAll()
        }
    }
}

struct QuizView: View {
    var flashcards: [Flashcard]

    @State private var isFlippedArray: [Bool]

    init(flashcards: [Flashcard]) {
        self.flashcards = flashcards
        self._isFlippedArray = State(initialValue: Array(repeating: false, count: flashcards.count))
    }

    var body: some View {
        ScrollView {
            VStack {
                Text("Quiz Screen")
                    .font(.largeTitle)
                    .padding()

                ForEach(Array(zip(flashcards, isFlippedArray)), id: \.0.id) { flashcard, isFlipped in
                    QuizCardView(flashcard: flashcard, isFlipped: isFlipped) { flipped in
                        if let index = flashcards.firstIndex(where: { $0.id == flashcard.id }) {
                            isFlippedArray[index] = flipped
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarItems(trailing:
            Button(action: resetQuiz) {
                Text("Reset")
                    .foregroundColor(.blue)
                    .padding()
            }
        )
        .navigationTitle("Quiz")
    }

    func resetQuiz() {
        withAnimation {
            isFlippedArray = Array(repeating: false, count: flashcards.count)
        }
    }
}

struct QuizCardView: View {
    let flashcard: Flashcard
    let isFlipped: Bool
    let onFlip: (Bool) -> Void

    var body: some View {
        VStack {
            if isFlipped {
                ScrollView {
                    Text("Answer: \(flashcard.answer)")
                        .padding()
                        .rotation3DEffect(
                            .degrees(180),
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                }
            } else {
                ScrollView {
                    Text("Question: \(flashcard.question)")
                        .padding()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.accentColor)
        .foregroundColor(.white)
        .cornerRadius(8)
        .onTapGesture {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


