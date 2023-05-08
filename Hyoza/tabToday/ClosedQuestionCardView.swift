//
//  ClosedQuestionCardView.swift
//  Hyoza
//
//  Created by HAN GIBAEK on 2023/05/09.
//

import SwiftUI

struct ClosedQuestionCardView: View {
    let difficulty: String
    let questionNumber: Int
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                CardView(backgroundColor: .backGroundLightOrange, cornerRadius: 13) {
                    Text(difficulty)
                        .font(.footnote)
                        .foregroundColor(.textOrange)
                }
                Spacer()
            }
            Text("Q\(questionNumber)")
                .font(.title)
            Spacer()
        }
    }
    
    init(_ difficulty: String, _ questionNumber: Int) {
        self.difficulty = difficulty
        self.questionNumber = questionNumber
    }
}

struct ClosedQuestionCardView_Previews: PreviewProvider {
    static var previews: some View {
        ClosedQuestionCardView("쉬움", 1)
    }
}
