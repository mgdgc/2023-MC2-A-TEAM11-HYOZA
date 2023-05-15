//
//  TodayView.swift
//  Hyoza
//
//  Created by 최명근 on 2023/05/07.
//
//
//
//  TodayView.swift
//  Hyoza
//
//  Created by 최명근 on 2023/05/07.

import SwiftUI
import CoreData

struct TodayView: View {
    @State var isQuestionBoxViewTapped: Bool = false
    @State var easyQuestions: [Question] = []
    @State var hardQuestions: [Question] = []
    @State var isContinueIconSmall: Bool = false
    @State var openDegree: Double = 90
    @State var closedDegree: Double = 0
    
    @Binding var continuousDayCount: Int
    @Binding var continueText: String?
    @Binding var continueTextOpacity: Double
    @Binding var tempTextStorage: String?
    @Binding var isContinueIconAnimating: Bool
    @Binding var selectedQuestion: Question?
    
    var body: some View {
        NavigationStack {
                VStack {
                    VStack(alignment: .leading) {
                        Text(Date().dateOnlyString)
                            .font(.footnote)
                            .foregroundColor(.textSecondaryColor)
                            .bold()
                            .offset(CGSize(width:0, height:8))
                        HStack {
                            Text("오늘의 질문")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.textBlack)
                            Spacer()
                            ContinueIconView(text: $continueText, textOpacity: $continueTextOpacity, continuousDayCount: $continuousDayCount)
                                .onTapGesture {
                                    if !isContinueIconAnimating {
                                        makeCoutinueIconLargeAndSmall()
                                    }
                                }
                        }
                    }
                    Spacer()
                    ZStack {
                        if isQuestionBoxViewTapped {
                            CardView(cornerRadius: 16, shadowColor: .black.opacity(0.05), shadowRadius: 12) {
                                QuestionCardView(openDegree: $openDegree, closedDegree: $closedDegree, easyQuestions: $easyQuestions, hardQuestions: $hardQuestions, selectedQuestion: $selectedQuestion)
                            }
                        } else {
                            CardView(cornerRadius: 16, shadowColor: .black.opacity(0.05), shadowRadius: 12) {
                                QuestionBoxView(easyQuestions: $easyQuestions, hardQuestions: $hardQuestions, isQuestionBoxViewTapped: $isQuestionBoxViewTapped)
                            }
                            .onTapGesture {
                                self.isQuestionBoxViewTapped.toggle()
                            }
                        }
                    }
                    Spacer()
                }
                .padding(20)
            .background(Color.backGroundWhite.ignoresSafeArea())
            .onAppear() {
                if selectedQuestion != nil || PersistenceController.shared.todayAnsweredQuestion != nil {
                    closedDegree = -90
                    openDegree = 0
                    isQuestionBoxViewTapped = true
                }
            }
        }
    }
    
    private func makeContinueIconSmall() {
        self.continueTextOpacity = 0
        withAnimation(.easeInOut(duration: 0.7)) {
            self.continueText = nil
        }
    }
    
    private func makeContinueIconLarge() {
        withAnimation(.easeInOut(duration: 0.7)) {
            self.continueText = tempTextStorage
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.continueTextOpacity = 1
        }
    }
    
    private func makeCoutinueIconLargeAndSmall() {
        self.isContinueIconAnimating = true
        makeContinueIconLarge()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            makeContinueIconSmall()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.isContinueIconAnimating = false
            }
        }
    }
}

struct ContinueIconView: View {
    @Binding var text: String?
    @Binding var textOpacity: Double
    @Binding var continuousDayCount: Int
    
    var body: some View {
        CardView(cornerRadius: 16, shadowColor: .black.opacity(0.05), shadowRadius: 12) {
            HStack(spacing: 0) {
                if let text {
                    Text(text)
                        .font(.caption)
                        .foregroundColor(.textColor)
                        .bold()
                        .padding(.horizontal, 6)
                        .opacity(textOpacity)
                        
                }
                switch continuousDayCount {
                case 1..<4:
                    Text("💛")
                case 4..<8:
                    Text("🧡")
                case 8..<15:
                    Text("❤️")
                case 15...:
                    Text("❤️‍🔥")
                default:
                    Text("🤍")
                }
            }
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView(continuousDayCount: .constant(0), continueText: .constant(nil), continueTextOpacity: .constant(1.0), tempTextStorage: .constant("작성을 시작해보세요!"), isContinueIconAnimating: .constant(false), selectedQuestion: .constant(nil))
    }
}
