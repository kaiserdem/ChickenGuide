//
//  QuizFeature.swift
//  ChickenApp
//
//  Created by Yaroslav Golinskiy on 19/09/2025.
//

import ComposableArchitecture

@Reducer
struct QuizFeature {
    @ObservableState
    struct State: Equatable {
        var questions: [QuizQuestion] = [
            QuizQuestion(
                id: "1",
                question: "How many years can a chicken live?",
                options: ["3-5 years", "5-8 years", "10-15 years", "20+ years"],
                correctAnswerIndex: 2,
                explanation: "Chickens can live up to 10-15 years with proper care."
            ),
            QuizQuestion(
                id: "2",
                question: "What color eggs can a chicken lay?",
                options: ["Only white", "Only brown", "White and brown", "Various colors"],
                correctAnswerIndex: 3,
                explanation: "Chickens can lay eggs of different colors: white, brown, cream, greenish, and even blue!"
            ),
            QuizQuestion(
                id: "3",
                question: "What is the 'pecking order'?",
                options: ["Feeding method", "Social hierarchy", "Sleeping method", "Breeding method"],
                correctAnswerIndex: 1,
                explanation: "Pecking order is the social hierarchy in a chicken flock."
            ),
            QuizQuestion(
                id: "4",
                question: "How many faces can a chicken remember?",
                options: ["10", "50", "100", "Cannot remember"],
                correctAnswerIndex: 2,
                explanation: "Chickens can remember up to 100 different faces and distinguish them."
            ),
            QuizQuestion(
                id: "5",
                question: "What is the normal body temperature of a chicken?",
                options: ["36-37°C", "38-39°C", "40-42°C", "43-45°C"],
                correctAnswerIndex: 2,
                explanation: "Normal chicken body temperature is 40-42°C."
            )
        ]
        
        var currentQuestionIndex = 0
        var selectedAnswerIndex: Int? = nil
        var showResult = false
        var score = 0
        var quizCompleted = false
    }
    
    enum Action {
        case selectAnswer(Int)
        case nextQuestion
        case restartQuiz
        case onAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .selectAnswer(index):
                state.selectedAnswerIndex = index
                state.showResult = true
                
                // Перевіряємо правильність відповіді
                let currentQuestion = state.questions[state.currentQuestionIndex]
                if index == currentQuestion.correctAnswerIndex {
                    state.score += 1
                }
                
                return .none
                
            case .nextQuestion:
                if state.currentQuestionIndex < state.questions.count - 1 {
                    state.currentQuestionIndex += 1
                    state.selectedAnswerIndex = nil
                    state.showResult = false
                } else {
                    state.quizCompleted = true
                }
                return .none
                
            case .restartQuiz:
                state.currentQuestionIndex = 0
                state.selectedAnswerIndex = nil
                state.showResult = false
                state.score = 0
                state.quizCompleted = false
                return .none
                
            case .onAppear:
                return .none
            }
        }
    }
}

struct QuizQuestion: Equatable, Identifiable {
    let id: String
    let question: String
    let options: [String]
    let correctAnswerIndex: Int
    let explanation: String
}
