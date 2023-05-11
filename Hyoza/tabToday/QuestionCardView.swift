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
    @Binding var easyQuestions: [QuerySentence]
    @Binding var hardQuestions: [QuerySentence]
    
    @State var selectedQuestion: QuerySentence = QuerySentence(id: 0, question: "", difficulty: .easy)
    
    var body: some View {
        ZStack {
            OpenCardView(degree: $openDegree, selectedQuestion: $selectedQuestion)
            ClosedCardListView(openDegree: $openDegree, closedDegree: $closedDegree, easyQuestions: $easyQuestions, hardQuestions: $hardQuestions, selectedQuestion: $selectedQuestion)
        }
    }
}

struct ClosedCardView: View {
    let question: QuerySentence
    let questionNumber: Int
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                CapsuleView(content: {
                    Text(question.difficulty == .easy ? "쉬움" : "어려움")
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
    
}

struct ClosedCardListView: View {
    @Binding var openDegree: Double
    @Binding var closedDegree: Double
    @Binding var easyQuestions: [QuerySentence]
    @Binding var hardQuestions: [QuerySentence]
    @Binding var selectedQuestion: QuerySentence
    
    var body: some View {
        ZStack{
            Color.backGroundWhite
            VStack(spacing: 20) {
                Text("오늘의 질문을 고르세요")
                    .font(.title)
                CardView(backgroundColor: .cardLightOrange, cornerRadius: 15, shadowColor: .black.opacity(0.1), shadowRadius: 8){
                    ClosedCardView(question: easyQuestions[0], questionNumber: 1)
                }
                .onTapGesture {
                    selectedQuestion = easyQuestions[0]
                    withAnimation(.linear(duration: 0.3)) {
                        closedDegree = -90
                    }
                    withAnimation(.linear(duration: 0.3).delay(0.3)){
                        openDegree = 0
                    }
                }
                CardView(backgroundColor: .cardLightOrange, cornerRadius: 15, shadowColor: .black.opacity(0.1), shadowRadius: 8){
                    ClosedCardView(question: hardQuestions[0], questionNumber: 2)
                }
                .onTapGesture {
                    selectedQuestion = hardQuestions[0]
                    withAnimation(.linear(duration: 0.3)) {
                        closedDegree = -90
                    }
                    withAnimation(.linear(duration: 0.3).delay(0.3)){
                        openDegree = 0
                    }
                }
                CardView(backgroundColor: .cardLightOrange, cornerRadius: 15, shadowColor: .black.opacity(0.1), shadowRadius: 8){
                    ClosedCardView(question: easyQuestions[1], questionNumber: 3)
                }
                .onTapGesture {
                    selectedQuestion = easyQuestions[1]
                    withAnimation(.linear(duration: 0.3)) {
                        closedDegree = -90
                    }
                    withAnimation(.linear(duration: 0.3).delay(0.3)){
                        openDegree = 0
                    }
                }
            }
            .padding(20)
        }
        .rotation3DEffect(Angle(degrees: closedDegree), axis: (0, 1, 0))
    }
}

struct OpenCardView: View {
    @Binding var degree: Double
    @Binding var selectedQuestion: QuerySentence
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.backGroundWhite
                VStack{
                    HStack {
                        CapsuleView(content: {
                            Text(selectedQuestion.difficulty == .easy ? "쉬움" : "어려움")
                                .font(.footnote)
                                .foregroundColor(.textOrange)
                                .padding([.leading, .trailing], 12)
                                .padding([.top, .bottom], 4)
                        }, capsuleColor: .backGroundLightOrange)
                        Spacer()
                        Text(Date().fullString)
                            .font(.footnote)
                            .foregroundColor(.tapBarDarkGray)
                        Spacer()
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.textOrange)
                    }
                    Spacer()
                    Text(selectedQuestion.question)
                        .font(.title)
                        .foregroundColor(.textBlack)
                        .bold()
                    Spacer()
                    CapsuleView(content: {
                        Text("답변하기")
                            .bold()
                            .font(.title2)
                            .foregroundColor(.textWhite)
                            .padding([.top, .bottom], 20)
                            .frame(width: geo.size.width)
                    }, capsuleColor: .backGroundOrange)
                }
            }
            .rotation3DEffect(Angle(degrees: degree), axis: (0, 1, 0))
        }
    }
    
}

struct QuestionCardView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionCardView(openDegree: .constant(-90), closedDegree: .constant(0), easyQuestions: .constant([QuerySentence(id: 1, question: "최근에 재미있게 본 유튜브 채널에 대해 말해주세요~", difficulty: .easy), QuerySentence(id: 2, question: "강아지가 좋나요, 고양이가 좋나요?", difficulty: .easy)]), hardQuestions: .constant([QuerySentence(id: 3, question: "인생에서 가장 중요시하는 가치가 무엇이신가요?", difficulty: .hard), QuerySentence(id: 4, question: "부모님에게 '부모님'이란 어떤 존재였나요?", difficulty: .hard)]), selectedQuestion: QuerySentence(id: 3, question: "인생에서 가장 중요시하는 가치가 무엇이신가요?", difficulty: .hard))
    }
}
