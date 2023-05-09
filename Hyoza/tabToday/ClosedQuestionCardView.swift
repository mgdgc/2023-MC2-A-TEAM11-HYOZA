//
//  ClosedQuestionCardView.swift
//  Hyoza
//
//  Created by HAN GIBAEK on 2023/05/09.
//

import SwiftUI

struct ClosedQuestionCardView: View {
    @State var difficulty: String
    @State var questionNumber: Int
    @State var questionContent: String
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                CapsuleView(content: {
                    Text(difficulty)
                        .font(.footnote)
                        .foregroundColor(.textOrange)
                        .padding([.leading, .trailing], 12)
                        .padding([.top, .bottom], 4)
                }, capsuleColor: .backGroundLightOrange)
                Spacer()
                //                CardView(backgroundColor: .backGroundLightOrange, cornerRadius: 10) {
                //                    Text(difficulty)
                //                        .font(.footnote)
                //                        .foregroundColor(.textOrange)
                //                        .frame(minWidth: 40, maxHeight: 12)
            }
            Spacer()
            Text("Q\(questionNumber)")
                .font(.title)
            Spacer()
            Text("")
            Spacer()
        }
    }
    
    init(_ difficulty: String, _ questionNumber: Int, _ questionContent: String = "최근에 가장 재미있게 본 유튜브 영상은 무엇인가요?") {
        self.difficulty = difficulty
        self.questionNumber = questionNumber
        self.questionContent = questionContent
    }
}

struct ClosedQuestionCardView_Previews: PreviewProvider {
    static var previews: some View {
        ClosedQuestionCardView("쉬움", 1)
    }
}
