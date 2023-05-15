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
    
    var body: some View {
        ZStack {
            OpenCardView(degree: $openDegree, selectedQuestion: $selectedQuestion)
                .zIndex(closedDegree == -90 ? 1 : 0)
                .onAppear {
                }
            ClosedCardListView(openDegree: $openDegree, closedDegree: $closedDegree, easyQuestions: $easyQuestions, hardQuestions: $hardQuestions, selectedQuestion: $selectedQuestion)
        }
        .frame(height: UIScreen.screenHeight * 0.6)
    }
}

struct QuestionCardView_Previews: PreviewProvider {
    static var previews: some View {
        let pc = PersistenceController.preview
        
        QuestionCardView(openDegree: .constant(90), closedDegree: .constant(0), easyQuestions: .constant(pc.easyQuestions), hardQuestions: .constant(pc.hardQuestions), selectedQuestion: .constant(nil))
        QuestionCardView(openDegree: .constant(90), closedDegree: .constant(0), easyQuestions: .constant(pc.easyQuestions), hardQuestions: .constant(pc.hardQuestions), selectedQuestion: .constant(pc.easyQuestions[0]))
    }
}

