//
//  ContentView.swift
//  edutainment
//
//  Created by Василий Буланов on 10/27/21.
//

import SwiftUI

struct questionAndAnswer {
    var question: String
    var answer: String
}

struct ContentView: View {
    
    @State var menuSelect = true
    @State var mulTable = 1
    @State var selectedCountOfQuestions = "1"
    @State var questions: Array<questionAndAnswer> = []
    
    var body: some View {
        if (menuSelect) {
            menu()
        } else {
            Text("Game")
        }
    }
    
    func menu() -> some View {
        NavigationView {
            Form {
                Section {
                    Text("Choose multiplication table")
                        .font(.headline)
                        .padding()
                    Stepper(value: $mulTable, in: 1...12, step: 1) {
                        Text("\(mulTable)x\(mulTable)")
                    }
                        .padding()
                }
                Section {
                    Text("Chose count of questions")
                        .font(.headline)
                        .padding()
                    Picker("", selection: $selectedCountOfQuestions) {
                        ForEach(getCountOfQuestins(size: mulTable * mulTable), id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.wheel)
                }
                Button("Start game"){
                    self.menuSelect.toggle()
                    setDictionary()
                    print(questions)
                }
            }
            .navigationTitle("Menu")
        }
    }
    
    func getCountOfQuestins(size: Int) -> Array<String> {
        var array = Array<String>()
        var iter = 5
        var sz = size
        
        if (sz > 5) {
            while (sz > size / 2) {
                array.append(String(iter))
                iter += 5
                sz -= 5
            }
        } else {
            iter = 1
            while (sz > size / 2) {
                array.append(String(iter))
                iter += 1
                sz -= 1
            }
        }
        if (size != 1) {
            array.append("All")
        }
        return array
    }
    
    func setDictionary(){
        var questions: Array<questionAndAnswer> = []
        let countOfQuestions = Int(selectedCountOfQuestions) ?? mulTable*mulTable
//        var randomElemnt: Int
        for x in 1...12 {
            for y in 1...12 {
                questions.append(questionAndAnswer(question: "\(x)x\(y)", answer: "\(x * y)"))
            }
        }
        self.questions = Array(questions.shuffled()[0..<countOfQuestions])
//        if (selectedCountOfQuestions.elementsEqual("All")) {
//            randomElemnt = Int.random(in: 0...(self.mulTable*self.mulTable))
//        } else {
//            randomElemnt = Int.random(in: 0...(Int(self.selectedCountOfQuestions)!*Int(self.selectedCountOfQuestions)!))
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
