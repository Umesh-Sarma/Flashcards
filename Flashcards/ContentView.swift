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
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)

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

                List(flashcards) { flashcard in
                    VStack(alignment: .leading) {
                        Text("Question: \(flashcard.question)")
                            .padding(.bottom, 4)

                        Text("Answer: \(flashcard.answer)")
                            .foregroundColor(.gray)
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
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .imageScale(.large)
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
        VStack {
            HStack {
                Spacer()
                Button(action: resetQuiz) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .padding()

            Text("Quiz Screen")
                .font(.largeTitle)
                .padding()

            ForEach(Array(zip(flashcards, isFlippedArray)), id: \.0.id) { flashcard, isFlipped in
                QuizCardView(flashcard: flashcard, isFlipped: isFlipped) { flipped in
                    if let index = flashcards.firstIndex(where: { $0.id == flashcard.id }) {
                        isFlippedArray[index] = flipped
                    }
                }
            }
        }
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
                Text("Answer: \(flashcard.answer)")
                    .padding()
                    .rotation3DEffect(
                        .degrees(180),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
            } else {
                Text("Question: \(flashcard.question)")
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
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
