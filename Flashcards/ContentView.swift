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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
