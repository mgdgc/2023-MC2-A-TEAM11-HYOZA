//
//  OpenQuestionCardView.swift
//  Hyoza
//
//  Created by HAN GIBAEK on 2023/05/09.
//

import SwiftUI

struct OpenQuestionCardView: View {
    @Binding var difficulty: String
    @Binding var questionNumber: Int
    @Binding var closedQuestionsDegree: Double
    @Binding var question1Degree: Double
    @Binding var question2Degree: Double
    @Binding var question3Degree: Double
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.backGroundWhite
                VStack{
                    HStack {
                        CapsuleView(content: {
                            Text(difficulty)
                                .font(.footnote)
                                .foregroundColor(.textOrange)
                                .padding([.leading, .trailing], 12)
                                .padding([.top, .bottom], 4)
                        }, capsuleColor: .backGroundLightOrange)
                        Spacer()
                        Text("2023년 5월 5일")
                            .font(.footnote)
                            .foregroundColor(.tapBarDarkGray)
                        Spacer()
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.textOrange)
                    }
                    Spacer()
                    Text("최근에 가장 재미있게 본 유튜브 영상은 무엇인가요?")
                        .font(.title)
                        .foregroundColor(.textBlack)
                        .bold()
                    Spacer()
                    CapsuleView(content: {
                        Text("열어보기")
                            .bold()
                            .font(.title2)
                            .foregroundColor(.textWhite)
                            .padding([.top, .bottom], 20)
                            .frame(width: geo.size.width)
                    }, capsuleColor: .backGroundOrange)
                }
            }
        }
    }
}

struct OpenQuestionCardView_Previews: PreviewProvider {
    static var previews: some View {
        OpenQuestionCardView(difficulty: .constant("쉬움"), questionNumber: .constant(1), closedQuestionsDegree: .constant(-90), question1Degree: .constant(0), question2Degree: .constant(0), question3Degree: .constant(0))
    }
}
