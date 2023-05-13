//
//  OpenCardView.swift
//  Hyoza
//
//  Created by HAN GIBAEK on 2023/05/12.
//

import SwiftUI

struct OpenCardView: View {
    @Environment(\.displayScale) var displayScale
    
    @State var imageToShareInQuestionCard: ImageWrapper? = nil
    
    @Binding var degree: Double
    @Binding var selectedQuestion: Question?
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    Color.backGroundWhite
                    if let selectedQuestion {
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
//<<<<<<< HEAD
//                                    .foregroundColor(.textOrange)
//                                    .padding([.leading, .trailing], 12)
//                                    .padding([.top, .bottom], 4)
//                            }, capsuleColor: .backGroundLightOrange)
//                            Spacer()
//                            Text(Date().fullString)
//                                .font(.footnote)
//                                .foregroundColor(.tapBarDarkGray)
//                            Spacer()
//                            Button(action: {
//                                var tempView: some View = sharedCardView(question: selectedQuestion)
//                                let viewToRender = tempView.frame(width: UIScreen.main.bounds.width)
//
//                                guard let image = viewToRender.render(scale: displayScale) else {
//                                    return
//                                }
//                                imageToShareInQuestionCard = ImageWrapper(image: image)
//                            }) {
//                                Image(systemName: "square.and.arrow.up")
//                                    .foregroundColor(.textOrange)
//=======
                                    .foregroundColor(.tapBarDarkGray)
                                Spacer()
                                Button(action: {
                                    Task {
                                        let viewToRender = self.frame(width: UIScreen.main.bounds.width)
                                        
                                        guard let image = await viewToRender.render(scale: displayScale) else {
                                            return
                                        }
                                        imageToShareInQuestionCard = ImageWrapper(image: image)
                                    }
                                }) {
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundColor(.textOrange)
                                }
                                .sheet(item: $imageToShareInQuestionCard) { imageToShareInQuestionCard in
                                    ActivityViewControllerWrapper(items: [imageToShareInQuestionCard.image], activities: nil)
                                }
//>>>>>>> acb5e76e19df9ce7039d6dede68b70787aedc190
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
                }
                .rotation3DEffect(Angle(degrees: degree), axis: (0, 1, 0))
            }
        }
    }
//<<<<<<< HEAD
//
//    private func sharedCardView(question: QuerySentence) -> some View {
//        ZStack {
//            Color.backGroundWhite
//            VStack{
//                HStack {
//                    CapsuleView(content: {
//                        Text(question.difficulty == .easy ? "쉬움" : "어려움")
//                            .font(.footnote)
//                            .foregroundColor(.textOrange)
//                            .padding([.leading, .trailing], 12)
//                            .padding([.top, .bottom], 4)
//                    }, capsuleColor: .backGroundLightOrange)
//                    Spacer()
//                    Text(Date().fullString)
//                        .font(.footnote)
//                        .foregroundColor(.tapBarDarkGray)
//                    Spacer()
//
//                }
//                Spacer()
//                Text(question.question)
//                    .font(.title)
//                    .foregroundColor(.textBlack)
//                    .bold()
//                Spacer()
//            }
//        }
//    }
//}
//
//struct OpenCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        OpenCardView(degree: .constant(90), selectedQuestion: .constant(QuerySentence(id: 3, question: "인생에서 가장 중요시하는 가치가 무엇이신가요?", difficulty: .hard)))
//    }
//=======
//>>>>>>> acb5e76e19df9ce7039d6dede68b70787aedc190
}
//
//struct OpenCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        OpenCardView(degree: .constant(90), selectedQuestion: .constant(QuerySentence(id: 3, question: "인생에서 가장 중요시하는 가치가 무엇이신가요?", difficulty: .hard)))
//    }
//}
