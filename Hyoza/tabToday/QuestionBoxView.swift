//
//  QuestionBoxView.swift
//  Hyoza
//
//  Created by HAN GIBAEK on 2023/05/09.
//

import SwiftUI

// TODO: - Action 하나의 함수로 묶고 두 버튼에 호출하기

struct QuestionBoxView: View {
    private let persistenceController = PersistenceController.shared
    @Binding var easyQuestions: [Question]
    @Binding var hardQuestions: [Question]
    @Binding var isQuestionBoxViewTapped: Bool
    
    var body: some View {
        VStack {
            Text("오늘의 질문 꾸러미")
                .font(.title)
                .bold()
                .foregroundColor(.textColor)
                .padding(.top, 30)
            Button {
                openQuestions()
            } label: {
                Image("questionBoxImage")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.capsuleColor)
                    .padding(30)
            }
            ButtonView(content: "열어보기") {
                openQuestions()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(height: UIScreen.screenHeight * 0.6)
    }
    
    func openQuestions() -> Void {
        easyQuestions = persistenceController.filteredQuestion(which: .isNotChoosenAndEasy)
        hardQuestions = persistenceController.filteredQuestion(which: .isNotChoosenAndHard)
        self.isQuestionBoxViewTapped.toggle()
    }
}

struct QuestionBoxView_Previews: PreviewProvider {
    static var previews: some View {
        let pc = PersistenceController.preview
        
        QuestionBoxView(easyQuestions: .constant(pc.easyQuestions), hardQuestions: .constant(pc.hardQuestions), isQuestionBoxViewTapped: .constant(false))
    }
}
