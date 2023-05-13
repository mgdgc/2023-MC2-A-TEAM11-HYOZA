//
//  QuestionBoxView.swift
//  Hyoza
//
//  Created by HAN GIBAEK on 2023/05/09.
//

import SwiftUI

struct QuestionBoxView: View {
    private let persistenceController = PersistenceController.shared
    @Binding var easyQuestions: [Question]
    @Binding var hardQuestions: [Question]
    @Binding var isQuestionBoxViewTapped: Bool
    
    var body: some View {
        ZStack{
            Color.backGroundWhite
            VStack {
                Text("오늘의 질문 꾸러미")
                    .font(.title)
                    .bold()
                    .foregroundColor(.textBlack)
                Button {
                    easyQuestions = persistenceController.filteredQuestion(which: .isNotChoosenAndEasy)
                    hardQuestions = persistenceController.filteredQuestion(which: .isNotChoosenAndHard)
                    self.isQuestionBoxViewTapped.toggle()
                } label: {
                    Image(systemName: "shippingbox.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.backGroundLightOrange)
                        .padding(20)
                }
            }
        }
    }
}

//struct QuestionBoxView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        QuestionBoxView(easyQuestions: .constant([QuerySentence(id: 1, question: "최근에 재미있게 본 유튜브 채널에 대해 말해주세요~", difficulty: .easy), QuerySentence(id: 2, question: "강아지가 좋나요, 고양이가 좋나요?", difficulty: .easy)]), hardQuestions: .constant([QuerySentence(id: 3, question: "인생에서 가장 중요시하는 가치가 무엇이신가요?", difficulty: .hard), QuerySentence(id: 4, question: "부모님에게 '부모님'이란 어떤 존재였나요?", difficulty: .hard)]), isQuestionBoxViewTapped: .constant(false))
//    }
//}
