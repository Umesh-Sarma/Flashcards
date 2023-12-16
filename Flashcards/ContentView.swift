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
        }
    }

    func addFlashcard() {
        guard !userQuestion.isEmpty && !userAnswer.isEmpty else { return }
        let newFlashcard = Flashcard(question: userQuestion, answer: userAnswer)
        flashcards.append(newFlashcard)
        userQuestion = ""
        userAnswer = ""
    }
}

struct QuizView: View {
    var flashcards: [Flashcard]

    var body: some View {
        VStack {
            Text("Quiz Screen")
                .font(.largeTitle)
                .padding()

            ForEach(flashcards) { flashcard in
                QuizCardView(flashcard: flashcard)
            }
        }
        .navigationTitle("Quiz")
    }
}

struct QuizCardView: View {
    @State private var isFlipped = false
    let flashcard: Flashcard

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
                self.isFlipped.toggle()
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


