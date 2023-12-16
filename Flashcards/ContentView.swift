//
//  ContentView.swift
//  Flashcards
//
//  Created by Umesh Sarma on 12/16/23.
//

import SwiftUI

struct ContentView: View {
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

                NavigationLink(destination: FlashcardView(question: userQuestion, answer: userAnswer)) {
                    Text("Create Flashcard")
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            .navigationTitle("FlashCards App")
        }
    }
}

struct FlashcardView: View {
    var question: String
    var answer: String

    var body: some View {
        VStack {
            Text("Question: \(question)")
                .padding()

            Text("Answer: \(answer)")
                .padding()
        }
        .navigationTitle("Flashcard")
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
