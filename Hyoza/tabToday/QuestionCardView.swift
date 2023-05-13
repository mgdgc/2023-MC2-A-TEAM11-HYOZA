//
//  QuestionCardView.swift
//  Hyoza
//
//  Created by HAN GIBAEK on 2023/05/09.
//

import SwiftUI

struct QuestionCardView: View {
    @Binding var openDegree: Double
    @Binding var closedDegree: Double
//    @State var openDegree: Double = 90
//    @State var closedDegree: Double = 0
    @Binding var easyQuestions: [Question]
    @Binding var hardQuestions: [Question]
    @Binding var selectedQuestion: Question?
    
    var body: some View {
        ZStack {
            Color.backGroundWhite
            OpenCardView(degree: $openDegree, selectedQuestion: $selectedQuestion)
            ClosedCardListView(openDegree: $openDegree, closedDegree: $closedDegree, easyQuestions: $easyQuestions, hardQuestions: $hardQuestions, selectedQuestion: $selectedQuestion)
        }
//        ZStack {
//            Color.backGroundWhite
//            CardView(cornerRadius: 16, shadowColor: .black.opacity(0.05), shadowRadius: 12) {
//                OpenCardView(degree: $openDegree, selectedQuestion: $selectedQuestion)
//            }
//            CardView(cornerRadius: 16, shadowColor: .black.opacity(0.05), shadowRadius: 12) {
//                ClosedCardListView(openDegree: $openDegree, closedDegree: $closedDegree, easyQuestions: $easyQuestions, hardQuestions: $hardQuestions, selectedQuestion: $selectedQuestion)
//            }
//        }
    }
}

//struct QuestionCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuestionCardView(easyQuestions: .constant([QuerySentence(id: 1, question: "최근에 재미있게 본 유튜브 채널에 대해 말해주세요~", difficulty: .easy), QuerySentence(id: 2, question: "강아지가 좋나요, 고양이가 좋나요?", difficulty: .easy)]), hardQuestions: .constant([QuerySentence(id: 3, question: "인생에서 가장 중요시하는 가치가 무엇이신가요?", difficulty: .hard), QuerySentence(id: 4, question: "부모님에게 '부모님'이란 어떤 존재였나요?", difficulty: .hard)]), selectedQuestion: QuerySentence(id: 3, question: "인생에서 가장 중요시하는 가치가 무엇이신가요?", difficulty: .hard))
//    }
//}
