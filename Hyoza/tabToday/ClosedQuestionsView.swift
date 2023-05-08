//
//  ClosedQuestionsView.swift
//  Hyoza
//
//  Created by HAN GIBAEK on 2023/05/09.
//

import SwiftUI

struct ClosedQuestionsView: View {
    var body: some View {
        ZStack{
            Color.backGroundWhite
            VStack(spacing: 20) {
                Text("오늘의 질문을 고르세요")
                    .font(.title)
//                Spacer()
                CardView(backgroundColor: .cardLightOrange){
                    ClosedQuestionCardView("쉬움", 1)
                }
//                Spacer()
                CardView(backgroundColor: .cardLightOrange){
                    ClosedQuestionCardView("어려움", 2)
                }
                CardView(backgroundColor: .cardLightOrange){
                    ClosedQuestionCardView("쉬움", 3)
                }
            }
            .padding(20)
        }
    }
}

struct ClosedQuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        ClosedQuestionsView()
    }
}
