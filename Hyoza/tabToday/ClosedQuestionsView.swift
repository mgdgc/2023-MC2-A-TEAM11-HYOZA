//
//  ClosedQuestionsView.swift
//  Hyoza
//
//  Created by HAN GIBAEK on 2023/05/09.
//

import SwiftUI

struct ClosedQuestionsView: View {
    @State var isQuestionPicked: Bool = false
    @State var closedQuestionsDegree: Double = -90
    @State var question1Degree: Double = 0.0
    @State var question2Degree: Double = 0.0
    @State var question3Degree: Double = 0.0
    
    var body: some View {
        ZStack{
            ZStack{
                Color.backGroundWhite
                VStack(spacing: 20) {
                    Text("오늘의 질문을 고르세요")
                        .font(.title)
                    CardView(backgroundColor: .cardLightOrange, cornerRadius: 15, shadowColor: .black.opacity(0.1), shadowRadius: 8){
                        ClosedQuestionCardView("쉬움", 1)
                    }
                    .onTapGesture {
                        withAnimation(.linear(duration: 0.3)){
                            closedQuestionsDegree = 0.0
                        }
                        withAnimation(.linear(duration: 0.3).delay(0.3)){
                            question1Degree = 90
                        }
                    }
                    CardView(backgroundColor: .cardLightOrange, cornerRadius: 15, shadowColor: .black.opacity(0.1), shadowRadius: 8){
                        ClosedQuestionCardView("어려움", 2)
                    }
                    .onTapGesture {
                        withAnimation(.linear(duration: 0.3)){
                            closedQuestionsDegree = 0.0
                        }
                        withAnimation(.linear(duration: 0.3).delay(0.3)){
                            question2Degree = 90
                        }
                    }
                    CardView(backgroundColor: .cardLightOrange, cornerRadius: 15, shadowColor: .black.opacity(0.1), shadowRadius: 8){
                        ClosedQuestionCardView("쉬움", 3)
                    }
                    .onTapGesture {
                        withAnimation(.linear(duration: 0.3)){
                            closedQuestionsDegree = 0
                        }
                        withAnimation(.linear(duration: 0.3).delay(0.3)){
                            question3Degree = 90
                        }
                    }
                }
                .padding(20)
            }
            .rotation3DEffect(Angle(degrees: closedQuestionsDegree), axis: (x: 0, y: 1, z: 0))
            OpenQuestionCardView(difficulty: .constant("쉬움"), questionNumber: .constant(1), closedQuestionsDegree: $closedQuestionsDegree, question1Degree: $question1Degree, question2Degree: $question2Degree, question3Degree: $question3Degree)
                .onTapGesture {
                    withAnimation(.linear(duration: 0.3)){
                        closedQuestionsDegree = 0
                    }
                    withAnimation(.linear(duration: 0.3).delay(0.3)){
                        question1Degree = 90
                    }
                    withAnimation(.linear(duration: 0.3).delay(0.3)){
                        question2Degree = 90
                    }
                    withAnimation(.linear(duration: 0.3).delay(0.3)){
                        question3Degree = 90
                    }
                }
                .rotation3DEffect(Angle(degrees: question1Degree), axis: (x:0, y:1, z:0))
        }
    }
}

struct ClosedQuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        ClosedQuestionsView()
    }
}
