//
//  ClosedCardListView.swift
//  Hyoza
//
//  Created by HAN GIBAEK on 2023/05/12.
//

import SwiftUI

struct ClosedCardListView: View {
    @Binding var openDegree: Double
    @Binding var closedDegree: Double
    @Binding var easyQuestions: [Question]
    @Binding var hardQuestions: [Question]
    @Binding var selectedQuestion: Question?
    
    var body: some View {
            VStack(spacing: 20) {
                Text("오늘의 질문을 골라주세요")
                    .font(.title)
                    .bold()
                    .foregroundColor(.textBlack)
                Text("질문은 하루에 하나만 열어볼 수 있어요!")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.textLightGray)
                if easyQuestions.count >= 2 && hardQuestions.count >= 1 {
                    closedCardView(question: easyQuestions[0], questionNumber: 1)
                    closedCardView(question: hardQuestions[0], questionNumber: 2)
                    closedCardView(question: easyQuestions[1], questionNumber: 3)
                }
            }
            .padding(20)
        .rotation3DEffect(Angle(degrees: closedDegree), axis: (0, 1, 0))
    }
    
    private func closedCardView(question: Question, questionNumber: Int) -> some View {
        var body: some View {
            CardView(backgroundColor: .cardLightOrange, cornerRadius: 15, shadowColor: .black.opacity(0.1), shadowRadius: 8){
                VStack{
                    Spacer()
                    HStack{
                        CapsuleView(content: {
                            Text(question.difficultyString)
                                .font(.footnote)
                                .foregroundColor(.textOrange)
                                .padding([.leading, .trailing], 12)
                                .padding([.top, .bottom], 4)
                        }, capsuleColor: .backGroundLightOrange)
                        Spacer()
                    }
                    Spacer()
                    Text("Q\(questionNumber)")
                        .font(.title)
                    Spacer()
                    Text("")
                    Spacer()
                }
            }
            .onTapGesture {
                PersistenceController.shared.addTimestamp(to: question)
                if selectedQuestion == nil {
                    selectedQuestion = PersistenceController.shared.selectedQuestion
                }
                print("[ClosedCardListView][\(#function)]\(selectedQuestion)")
                withAnimation(.linear(duration: 0.3)) {
                    closedDegree = -90
                }
                withAnimation(.linear(duration: 0.3).delay(0.3)){
                    openDegree = 0
                }
            }
        }
        return body
    }
}

struct ClosedCardListView_Previews: PreviewProvider {
    static var previews: some View {
        let pc = PersistenceController.preview
        ClosedCardListView(openDegree: .constant(90), closedDegree: .constant(0), easyQuestions: .constant(pc.easyQuestions), hardQuestions: .constant(pc.hardQuestions), selectedQuestion: .constant(nil))
    }
}
