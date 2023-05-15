//
//  TodayView.swift
//  Hyoza
//
//  Created by 최명근 on 2023/05/07.
//

import SwiftUI
import CoreData

struct TodayView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var isQuestionBoxViewTapped: Bool = false
    @State var easyQuestions: [QuerySentence] = QuerySentenceManager.shared.filtered(difficulty: .easy)
    @State var hardQuestions: [QuerySentence] = QuerySentenceManager.shared.filtered(difficulty: .hard)
    @State var isContinueIconSmall: Bool = false
    @State var continueText: String? = nil
    @State var continueTextOpacity: Double = 1.0
    @State var isContinueIconAnimating: Bool = false
    @State var continuousDayCount: Int = 0
    
    @State var tempTextStorage: String? = nil
    
    var body: some View {
        ZStack {
            Color.backGroundWhite
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 20) {
                Text(Date().dateOnlyString)
                    .font(.system(.footnote))
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
                ZStack {
                    CardView(cornerRadius: 16, shadowColor: .black.opacity(0.05), shadowRadius: 12) {
                        QuestionCardView(easyQuestions: $easyQuestions, hardQuestions: $hardQuestions)
                    }
                    .zIndex(isQuestionBoxViewTapped ? 1 : 0)
                    CardView(cornerRadius: 16, shadowColor: .black.opacity(0.05), shadowRadius: 12) {
                        QuestionBoxView(easyQuestions: $easyQuestions, hardQuestions: $hardQuestions, isQuestionBoxViewTapped: $isQuestionBoxViewTapped)
                    }
                    .onTapGesture {
                        self.isQuestionBoxViewTapped.toggle()
                    }
                    .zIndex(isQuestionBoxViewTapped ? 0 : 1)
                }
                Spacer()
            }
            .padding(20)
            
        }
        .onAppear() {
            continuousDayCount = AttendanceManager().isAttending ? AttendanceManager().getAttendanceDay() : 0
            
            switch continuousDayCount {
            case 0:
                tempTextStorage = "작성을 시작해보세요!"
                continueText = tempTextStorage
            case 1...:
                tempTextStorage = "연속 작성 \(continuousDayCount)일째 돌파!"
                continueText = tempTextStorage
            default:
                tempTextStorage = "무언가 잘못됐어요 :("
                continueText = tempTextStorage
            }
            
            if !isContinueIconAnimating {
                self.isContinueIconAnimating = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    makeContinueIconSmall()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        self.isContinueIconAnimating = false
                    }
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
            HStack {
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
                if let text {
                    Text(text)
                        .font(.caption)
                        .bold()
                        .opacity(textOpacity)
                }
            }
        }
        //        .onAppear() {
        //            continuousDayCount = AttendanceManager().isAttending ? AttendanceManager().getAttendanceDay() : 0
        //        }
        
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
