//
//  QnAView.swift
//  Hyoza
//
//  Created by 조한동 on 2023/05/09.
//

import SwiftUI

// TODO: - 좌우 전체 마진 20으로 통일하기 (여기 포함 전반적인 뷰)

// TODO: - 출판하기 버튼이 좀 더 넓었으면 좋겠다. (온보딩뷰와 같이)
// TODO: - 출판하기 버튼 누르면 공유하기
// TODO: - 질문 고르기 카드에서 글자와 타이틀이 조금 더 붙었으면
// TODO: - 옹졸제이뷰 해결
/// TODO: - Comment를 삭제하니까 padding이 한 세트 삭제됨. 있으면 2세트됨.
// TODO: - 열어보기 뷰에서 버튼에 action function 넣기
// TODO: - 오늘 QnA 카드 뷰 이미지 넣기



struct QnAView: View {
    
    var data: Question
    
    @State var isEditing: Bool = false
    @State var textValue = ""
    @State var commentTextField = ""
    @State var comment : String = ""
    @State private var imageToShare: ImageWrapper? = nil
    @State private var showingAlert = false
    @State var isTextFieldEmpty : Bool = true
    @State var isCommetFieldEmpty : Bool = true
    
    @EnvironmentObject var persistenceController: PersistenceController
    private let pastboard = UIPasteboard.general
    
    @Environment(\.displayScale) var displayScale
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            //contentView + ComentEditView
            VStack(alignment: .leading, spacing: 15) {
                ScrollView {
                    contentView
                        .padding(.horizontal, 20)
                }
                Spacer()
                commentEditView
                    .padding(.horizontal, 20)
            }
        }
        .background(
            Color.backgroundColor
                .ignoresSafeArea()
        )
        .navigationTitle("오늘의 질문")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button( action: {
                if isEditing{ showingAlert = true
                } else {
                    dismiss()
                }
            }) {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.orange)
            }
                .alert(isPresented: $showingAlert) {
                    // 머무르기 버튼 눌렀을 때 발생할 이벤트
                    let stayButton = Alert.Button.default(Text("머무르기").foregroundColor(.blue)) {
                    }
                    // 나가기 버튼 눌렀을 때 발생할 이벤트
                    let exitButton = Alert.Button.destructive(Text("나가기")) {
                        dismiss()
                    }
                    return Alert(title: Text("이전 페이지로 이동 시,\n 작성 중인 내용은 삭제됩니다."),
                                 message: Text("그래도 나가시겠습니까?"),
                                 primaryButton: stayButton,
                                 secondaryButton: exitButton)
                    
                },
            trailing: HStack {
                if isEditing {
                    Button(action: {
                        if !isTextFieldEmpty {
                            isEditing = false
                        } else {
                            print("텍스트를 입력해주세요.")
                        }
                        persistenceController.updateAnswer(content: textValue, relateTo: data)
                        data.objectWillChange.send()
                    }) {
                        Text("완료")
                            .foregroundColor(isTextFieldEmpty ? .gray : .orange)
                    }
                } else {
                    HStack {
                        Button(action: {
                            Task {
                                let viewToRender = contentView.frame(width: UIScreen.main.bounds.width)
                                //TODO: 이 코드가 뭔지 꼭 공부할것
                                guard let image = viewToRender.render(scale: displayScale) else {return}
                                imageToShare = ImageWrapper(image: image)
                            }
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.orange)
                        }
                        .padding(.trailing)
                        .sheet(item: $imageToShare) { imageToShare in
                            ActivityViewControllerWrapper(items: [imageToShare.image],
                                                          activities: nil)
                        }
                        Button(action: {
                            isEditing = true
                            isTextFieldEmpty = false
                            textValue = data.wrappedAnswer.answerDetail
                            if data.wrappedAnswer.comment != nil {
                                comment = data.wrappedAnswer.comment ?? "Unknown Error"
                            }
                        }) {
                            Image(systemName: "pencil")
                                .foregroundColor(.orange)
                        }
                    }
                }
            })
    }
    
    var contentView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Group {
                HStack{
                    DifficultyCapsuleView(difficulty: data.difficultyString)
                }
                .padding(.top, 30)
                Text(data.wrappedQuestion)
                    .font(.title.bold())
                    .foregroundColor(.textBlack)
                    
                Text(data.wrappedTimestamp.fullString)
                    .font(.subheadline)
                    .foregroundColor(.tapBarDarkGray)
            }
            
            Group {
                ZStack(alignment: .leading) {
                    if isEditing {
                        TextField("답변을 입력해 주세요.", text: $textValue, axis: .vertical)
                            .onChange(of: textValue) { newValue in
                                isTextFieldEmpty = newValue.isEmpty
                            }
                            .font(.body)
                            .foregroundColor(.textBlack)
                            .multilineTextAlignment(.leading)
                            .opacity(isEditing ? 0.5 : 1)
                    } else {
                        Text(data.wrappedAnswer.answerDetail)
                            .font(.body)
                            .foregroundColor(.textBlack)
                    }
                }
            }
            
            
            /// comment view
            if !isEditing,
               let commentDetail = data.answer?.comment,
               commentDetail != "" {
                HStack {
                    Spacer()
                    Text(commentDetail)
                        .font(.subheadline)
                        .foregroundColor(.textBlack)
                        .padding(.all)
                        .background(
                            Rectangle()
                                .cornerRadius(20, corners: [.topLeft ,.topRight, .bottomLeft] )
                                .foregroundColor(.white)
                                .shadow(radius: 1)
                        )
                        .contextMenu {
                            Button("복사", role: .none) {
                                pastboard.string = commentDetail
                            }
                            Button("삭제", role: .destructive) {
                                persistenceController.deleteComment(relatedTo: data)
                                comment = ""
                                isCommetFieldEmpty = true
                            }
                        }
                }
                .padding(.bottom, 30)
            }
        }
    }
    
    var commentEditView: some View {
        ZStack {
            if isEditing == false {
                if data.answer?.comment == nil || data.answer?.comment == "" {
                    HStack {
                        TextField("나의 한 마디 작성하기", text: $commentTextField)
                            .onChange(of: commentTextField) { newValue in
                                isCommetFieldEmpty = newValue.isEmpty
                            }
                        Spacer()
                        Button(action: {
                            comment = commentTextField
                            if !isCommetFieldEmpty && comment != "" {
                                saveItem()
                            } else {
                                print("코멘트를 입력해주세요.")
                            }
                        }) {
                            Text("게시")
                                .foregroundColor(isCommetFieldEmpty ? .gray : .orange)
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: .infinity)
                            .fill(.white)
                            .shadow(radius: 5)
                            .opacity(0.5)
                    )
                    .padding(.bottom, 24)
                }
                
            }
        }
    }
    
    func saveItem() {
        comment = commentTextField
        commentTextField = ""
        persistenceController.addComment(detail: comment, relatedTo: data)
    }
    
}

struct ImageWrapper: Identifiable {
    var id: UUID = UUID()
    var image: UIImage
}




struct QnA_Previews: PreviewProvider {
    static var previews: some View {
        let pc = PersistenceController.preview
        QnAView(data: pc.latestAnsweredQuestion!, isEditing: true, isTextFieldEmpty: true, isCommetFieldEmpty: true)
    }
}
