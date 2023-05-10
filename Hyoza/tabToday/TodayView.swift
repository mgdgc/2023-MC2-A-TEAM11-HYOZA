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
    
    @State var zIndexQuestionBox: Double = 1
    @State var zIndexQuestionCard: Double = 0
    
    @State var openDegree: Double = -90
    @State var closedDegree: Double = 0
    
    @State var question1Difficulty: String = "쉬움"
    @State var question2Difficulty: String = "어려움"
    @State var question3Difficulty: String = "쉬움"
    
    @State var easyQuestions: [QuerySentence] = QuerySentenceManager.shared.filtered(difficulty: .easy)
    @State var hardQuestions: [QuerySentence] = QuerySentenceManager.shared.filtered(difficulty: .hard)
    
    var body: some View {
        ZStack {
            Color.backGroundWhite
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 20) {
                Text("5월 5일 금요일")
                    .font(.system(.footnote))
                HStack {
                    Text("오늘의 질문")
                        .font(.largeTitle)
                    Spacer()
                    Image(systemName: "flame.fill")
                    Text("+12")
                }
                Spacer()
                ZStack {
                    CardView(cornerRadius: 16, shadowColor: .black.opacity(0.05), shadowRadius: 12) {
                        QuestionBoxView(easyQuestions: $easyQuestions, hardQuestions: $hardQuestions, zIndexQuestionBox: $zIndexQuestionBox,  zIndexQuestionCard: $zIndexQuestionCard)
                    }
                    .zIndex(zIndexQuestionBox)
                    CardView(cornerRadius: 16, shadowColor: .black.opacity(0.05), shadowRadius: 12) {
                        //                        ClosedQuestionsView()
                        QuestionCardView(openDegree: $openDegree, closedDegree: $closedDegree, question1Difficulty: $question1Difficulty, question2Difficulty: $question2Difficulty, question3Difficulty: $question3Difficulty, easyQuestions: $easyQuestions, hardQuestions: $hardQuestions)
                    }
                    .zIndex(zIndexQuestionCard)
                }
                Spacer()
            }
            .padding(20)
            
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
