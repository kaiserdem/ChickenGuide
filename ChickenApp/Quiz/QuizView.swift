//
//  QuizView.swift
//  ChickenApp
//
//  Created by Yaroslav Golinskiy on 19/09/2025.
//

import SwiftUI
import ComposableArchitecture

struct QuizView: View {
    let store: StoreOf<QuizFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                ZStack {
                    Theme.Gradients.quiz
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                    if viewStore.quizCompleted {
                        QuizResultView(store: store)
                    } else {
                        QuizQuestionView(store: store)
                    }
                }
                }
                .navigationTitle("Chicken Quiz")
                .navigationBarTitleDisplayMode(.large)
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
        }
    }
}

struct QuizQuestionView: View {
    let store: StoreOf<QuizFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ScrollView {
                VStack(spacing: 20) {
                    // Progress
                    VStack(spacing: 10) {
                        HStack {
                            Text("Question \(viewStore.currentQuestionIndex + 1) of \(viewStore.questions.count)")
                                .font(.headline)
                                .foregroundColor(Theme.Palette.white.opacity(Theme.Opacity.textSecondary))
                            
                            Spacer()
                            
                            Text("Score: \(viewStore.score)")
                                .font(.headline)
                                .foregroundColor(Theme.Palette.goldAccent)
                        }
                        
                        ProgressView(value: Double(viewStore.currentQuestionIndex + 1), total: Double(viewStore.questions.count))
                            .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Question
                    let currentQuestion = viewStore.questions[viewStore.currentQuestionIndex]
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text(currentQuestion.question)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.Palette.white)
                            .multilineTextAlignment(.leading)
                        
                        VStack(spacing: 15) {
                            ForEach(Array(currentQuestion.options.enumerated()), id: \.offset) { index, option in
                                AnswerButton(
                                    text: option,
                                    isSelected: viewStore.selectedAnswerIndex == index,
                                    isCorrect: viewStore.showResult && index == currentQuestion.correctAnswerIndex,
                                    isWrong: viewStore.showResult && viewStore.selectedAnswerIndex == index && index != currentQuestion.correctAnswerIndex,
                                    isDisabled: viewStore.showResult
                                ) {
                                    if !viewStore.showResult {
                                        viewStore.send(.selectAnswer(index))
                                    }
                                }
                            }
                        }
                        
                        // Explanation
                        if viewStore.showResult {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Explanation:")
                                    .font(.headline)
                                    .foregroundColor(Theme.Palette.white)
                                
                                Text(currentQuestion.explanation)
                                    .font(.body)
                                    .foregroundColor(Theme.Palette.white.opacity(Theme.Opacity.textSecondary))
                                    .padding()
                                    .background(Theme.Palette.white.opacity(Theme.Opacity.cardBackground))
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Next Button
                    if viewStore.showResult {
                        Button(action: {
                            viewStore.send(.nextQuestion)
                        }) {
                            Text(viewStore.currentQuestionIndex < viewStore.questions.count - 1 ? "Next Question" : "Finish Quiz")
                                .font(.headline)
                                .foregroundColor(Theme.Palette.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Theme.Gradients.button)
                                .cornerRadius(15)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
    }
}

struct AnswerButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let isWrong: Bool
    let isDisabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.body)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if isCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else if isWrong {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
            }
            .padding()
            .background(backgroundColor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 2)
            )
        }
        .disabled(isDisabled)
    }
    
    private var textColor: Color {
        if isCorrect || isWrong {
            return Theme.Palette.white
        }
        return isSelected ? Theme.Palette.white : Theme.Palette.white
    }
    
    private var backgroundColor: Color {
        if isCorrect {
            return Theme.Palette.successGreen.opacity(Theme.Opacity.cardBackground)
        } else if isWrong {
            return Theme.Palette.errorRed.opacity(Theme.Opacity.cardBackground)
        } else if isSelected {
            return Theme.Palette.goldAccent
        } else {
            return Theme.Palette.white.opacity(Theme.Opacity.cardBackground)
        }
    }
    
    private var borderColor: Color {
        if isCorrect {
            return Theme.Palette.successGreen
        } else if isWrong {
            return Theme.Palette.errorRed
        } else if isSelected {
            return Theme.Palette.goldAccent
        } else {
            return .clear
        }
    }
}

struct QuizResultView: View {
    let store: StoreOf<QuizFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 30) {
                Spacer()
                
                // Result
                VStack(spacing: 20) {
                    Text("🎉")
                        .font(.system(size: 80))
                    
                    Text("Quiz Completed!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.Palette.white)
                    
                    Text("Your result: \(viewStore.score) out of \(viewStore.questions.count)")
                        .font(.title2)
                        .foregroundColor(Theme.Palette.white.opacity(Theme.Opacity.textSecondary))
                    
                    // Grade
                    let percentage = Double(viewStore.score) / Double(viewStore.questions.count) * 100
                    Text(gradeText(percentage: percentage))
                        .font(.headline)
                        .foregroundColor(gradeColor(percentage: percentage))
                        .padding()
                        .background(gradeColor(percentage: percentage).opacity(Theme.Opacity.cardBackground))
                        .cornerRadius(10)
                }
                
                Spacer()
                
                // Restart Button
                Button(action: {
                    viewStore.send(.restartQuiz)
                }) {
                    Text("Try Again")
                        .font(.headline)
                        .foregroundColor(Theme.Palette.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.Gradients.button)
                        .cornerRadius(15)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
    }
    
    private func gradeText(percentage: Double) -> String {
        switch percentage {
        case 80...100:
            return "Excellent! 🏆"
        case 60..<80:
            return "Good! 👍"
        case 40..<60:
            return "Not bad! 👌"
        default:
            return "Try again! 💪"
        }
    }
    
    private func gradeColor(percentage: Double) -> Color {
        switch percentage {
        case 80...100:
            return .green
        case 60..<80:
            return .blue
        case 40..<60:
            return .orange
        default:
            return .red
        }
    }
}

#Preview {
    QuizView(
        store: Store(initialState: QuizFeature.State()) {
            QuizFeature()
        }
    )
}
