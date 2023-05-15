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
                    OpenCardTitleView(difficulty: selectedQuestion.difficultyString)
                    Spacer()
                    Text(selectedQuestion.wrappedQuestion)
                        .font(.title)
                        .foregroundColor(.textColor)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 5)
                    Spacer()
                    NavigationLink {
                        QnAView(data: selectedQuestion, isEditing: true)
                    } label: {
                        ButtonView(content: "답변하기") {
                            print("hehe")
                        }
                        .disabled(true)
                    }
                }
            }
        } else {
            Text("Here idiot")
        }
    }
}

struct OpenCardTitleView: View {
    let difficulty: String
    let horizontalPadding: CGFloat = 10
    let topPadding: CGFloat = 10
    
    var body: some View {
        ZStack {
            HStack {
                DifficultyCapsuleView(difficulty: difficulty)
                    .padding(.leading, horizontalPadding)
                Spacer()
                ShareButtonView(content: AnyView(self))
                    .padding(.trailing, horizontalPadding)
            }
            HStack {
                Spacer()
                Text(Date().fullString)
                    .font(.subheadline)
                    .foregroundColor(.textSecondaryColor)
                Spacer()
            }
        }
        .padding(.top, topPadding)
    }
}

struct AnswerView: View {
    @Environment(\.displayScale) var displayScale
    var imageToShareInQuestionCard: ImageWrapper? = nil
    @Binding var todayAnsweredQuestion: Question?
    
    var body: some View {
        if let todayAnsweredQuestion = todayAnsweredQuestion {
            NavigationLink {
                QnAView(data: todayAnsweredQuestion, isEditing: false)
            } label: {
                VStack{
                    OpenCardTitleView(difficulty: todayAnsweredQuestion.difficultyString)
                    Spacer()
                    Text(todayAnsweredQuestion.wrappedQuestion)
                        .font(.title)
                        .foregroundColor(.textColor)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 5)
                    Spacer()
                    Text(todayAnsweredQuestion.answer?.answerDetail ?? "답변이 없습니다")
                        .font(.title3)
                        .foregroundColor(.textBlack)
                    Spacer()
                }
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
                .foregroundColor(.textPointColor)
                .font(.title3)
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
