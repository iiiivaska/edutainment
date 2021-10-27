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
    
    @State var score = 0
    @State var numberOfQuestion = 0
    @State var menuSelect = true
    @State var mulTable = 1
    @State var selectedCountOfQuestions = "1"
    @State var questions: Array<questionAndAnswer> = []
    @State var answer: String = ""
    @State var endGame = false
    @FocusState private var amountIsFocused: Bool
    @State var bottomColor: Color? = nil
    var body: some View {
        if (menuSelect) {
            menu()
        } else {
            game()
                .alert(isPresented: $endGame) {
                    Alert(title: Text("Finish"), message: Text("Your score is \(score)/\(self.questions.count)"), dismissButton: .default(Text("Continue")) {
                        withAnimation {
                            self.menuSelect.toggle()
                        }
                        self.score = 0
                        self.answer = ""
                        self.numberOfQuestion = 0
                        self.selectedCountOfQuestions = "1"
                    })
                }
        }
    }
    
    func game() -> some View {
        NavigationView {
            Form {
                Section {
                    Text("What is \(questions[numberOfQuestion].question)")
                        .font(.headline)
                        .padding()
                    TextField("Answer", text: $answer)
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                }
                Button("Take my answer") {
                    nextQuestion()
                }
                .foregroundColor(bottomColor)
                Button("Menu") {
                    self.endGame.toggle()
                }
            }
            .navigationTitle("Game")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        nextQuestion()
                        amountIsFocused = false
                    }
                }
            }
        }
    }
    
    func nextQuestion() {
        if (questions[numberOfQuestion].answer.elementsEqual(self.answer)) {
            self.score += 1
            withAnimation() {
                self.bottomColor = Color.green
            }
        } else {
            withAnimation() {
                self.bottomColor = Color.red
            }
        }
        if (self.numberOfQuestion + 1 == self.questions.count) {
            self.endGame.toggle()
            return
        }
        self.answer = ""
        self.numberOfQuestion += 1
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
                    setDictionary()
                    withAnimation {
                        self.menuSelect.toggle()
                    }
                    //print(questions)
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
        var countOfQuestions = Int(selectedCountOfQuestions) ?? (mulTable*mulTable - 1)
        if (selectedCountOfQuestions.elementsEqual("1") && mulTable > 2) {
            countOfQuestions = 5
        }
        for x in 1...mulTable {
            for y in 1...mulTable {
                questions.append(questionAndAnswer(question: "\(x)x\(y)", answer: "\(x * y)"))
            }
        }
        self.questions = Array(questions.shuffled()[0..<countOfQuestions])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
