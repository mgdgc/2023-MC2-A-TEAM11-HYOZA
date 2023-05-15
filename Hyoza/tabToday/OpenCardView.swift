//
//  OpenCardView.swift
//  Hyoza
//
//  Created by HAN GIBAEK on 2023/05/12.
//

import SwiftUI

struct OpenCardView: View {
    @Environment(\.displayScale) var displayScale
    
    var imageToShareInQuestionCard: ImageWrapper? = nil
    
    @Binding var degree: Double
    @Binding var selectedQuestion: Question?
    @State var todayAnsweredQuestion: Question? = nil
    
    var body: some View {
        ZStack {
            if todayAnsweredQuestion != nil {
                AnswerView(todayAnsweredQuestion: $todayAnsweredQuestion)
                    .rotation3DEffect(Angle(degrees: degree), axis: (0, 1, 0))
            } else {
                NoAnswerView(selectedQuestion: $selectedQuestion)
                    .rotation3DEffect(Angle(degrees: degree), axis: (0, 1, 0))
            }
        }
        .onAppear {
            todayAnsweredQuestion = PersistenceController.shared.todayAnsweredQuestion
        }
    }
}

struct NoAnswerView: View {
    @Environment(\.displayScale) var displayScale
    @State var imageToShareInQuestionCard: ImageWrapper? = nil
    @Binding var selectedQuestion: Question?
    
    var body: some View {
        if let selectedQuestion = selectedQuestion {
            GeometryReader { geo in
                VStack{
                    HStack {
                        CapsuleView(content: {
                            Text(selectedQuestion.difficultyString)
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
                        ShareButtonView(content: AnyView(self))
                    }
                    Spacer()
                    Text(selectedQuestion.wrappedQuestion)
                        .font(.title)
                        .foregroundColor(.textBlack)
                        .bold()
                    Spacer()
                    NavigationLink {
                        QnAView(data: selectedQuestion, isEditing: true)
                    } label: {
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
            }
        } else {
            Text("Here idiot")
        }
    }
}

struct AnswerView: View {
    @Environment(\.displayScale) var displayScale
    var imageToShareInQuestionCard: ImageWrapper? = nil
    @Binding var todayAnsweredQuestion: Question?
    
    var body: some View {
        if let todayAnsweredQuestion = todayAnsweredQuestion {
                VStack{
                    HStack {
                        CapsuleView(content: {
                            Text(todayAnsweredQuestion.difficultyString)
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
                        ShareButtonView(content: AnyView(self))
                    }
                    Spacer()
                    Text(todayAnsweredQuestion.wrappedQuestion)
                        .font(.title)
                        .foregroundColor(.textBlack)
                        .bold()
                    Spacer()
                    Text(todayAnsweredQuestion.answer?.answerDetail ?? "답변이 없습니다")
                        .font(.title3)
                        .foregroundColor(.textBlack)
                    Spacer()
                }
        }
    }
}

struct ShareButtonView: View {
    @Environment(\.displayScale) var displayScale
    @State var imageToShareInQuestionCard: ImageWrapper? = nil
    
    let content: AnyView
    
    var body: some View {
        Button(action: {
            let viewToRender = content.frame(idealWidth: UIScreen.main.bounds.width, minHeight: 500)
            
            guard let image = viewToRender.render(scale: displayScale) else {
                return
            }
            imageToShareInQuestionCard = ImageWrapper(image: image)
        }) {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(.textOrange)
        }
        .sheet(item: $imageToShareInQuestionCard) { imageToShareInQuestionCard in
            ActivityViewControllerWrapper(items: [imageToShareInQuestionCard.image], activities: nil)
        }
    }
}

struct OpenCardView_Previews: PreviewProvider {
    static var previews: some View {
        let pc = PersistenceController.preview
        OpenCardView(degree: .constant(90), selectedQuestion: .constant(pc.easyQuestions[0]))
        OpenCardView(degree: .constant(0), selectedQuestion: .constant(pc.easyQuestions[0]))
    }
}
