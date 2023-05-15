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
    @Binding var easyQuestions: [Question]
    @Binding var hardQuestions: [Question]
    @Binding var selectedQuestion: Question?
    @Binding var isAnswered: Bool
    
    var body: some View {
        ZStack {
            OpenCardView(degree: $openDegree, selectedQuestion: $selectedQuestion, isAnswered: $isAnswered)
                .zIndex(closedDegree == -90 ? 1 : 0)
                .onAppear {
//                    print(selectedQuestion?.answer)
                }
            ClosedCardListView(openDegree: $openDegree, closedDegree: $closedDegree, easyQuestions: $easyQuestions, hardQuestions: $hardQuestions, selectedQuestion: $selectedQuestion)
        }
    }
}

struct QuestionCardView_Previews: PreviewProvider {
    static var previews: some View {
        let pc = PersistenceController.preview
        
        QuestionCardView(openDegree: .constant(90), closedDegree: .constant(0), easyQuestions: .constant(pc.easyQuestions), hardQuestions: .constant(pc.hardQuestions), selectedQuestion: .constant(nil), isAnswered: .constant(false))
        QuestionCardView(openDegree: .constant(90), closedDegree: .constant(0), easyQuestions: .constant(pc.easyQuestions), hardQuestions: .constant(pc.hardQuestions), selectedQuestion: .constant(pc.easyQuestions[0]), isAnswered: .constant(false))
    }
}

