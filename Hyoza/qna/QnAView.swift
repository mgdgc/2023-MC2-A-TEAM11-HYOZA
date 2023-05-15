//
//  QnAView.swift
//  Hyoza
//
//  Created by 조한동 on 2023/05/09.
//

import SwiftUI



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
            //배경 색
            Color.backgroundColor
                .ignoresSafeArea()
            //contentView + ComentEditView
            VStack(alignment: .leading, spacing: 15) {
                ScrollView {
                    contentView
                }
                Spacer()
                commentEditView
            }
        }
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
                        <<<<<<< HEAD
                        persistenceController.addAnswer(content: textValue, relateTo: data)
                        persistenceController.addComment(detail: comment, relatedTo: data)
                        
                        
                        
                        =======
                        persistenceController.updateAnswer(content: textValue, relateTo: data)
                        data.objectWillChange.send()
                        >>>>>>> d4aeccf6e636ea135debc119a36cafacd9e7508d
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
                                guard let image = await viewToRender.render(scale: displayScale) else {return}
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
            HStack{
                
                
                Text(data.difficultyString)
                    .foregroundColor(.orange)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Rectangle()
                            .cornerRadius(30)
                            .foregroundColor(.orange)
                            .opacity(0.2)
                    )
            }
            .padding([.top, .leading], 30)
            Text(data.wrappedQuestion)
                .font(.system(size: 25))
                .padding(.horizontal, 30)
            Text(data.wrappedTimestamp.fullString)
                .padding(.leading, 30)
                .foregroundColor(.secondary)
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .frame(height: 60)
                    .foregroundColor(.clear)
                if isEditing {
                    TextField("답변을 입력해 주세요.", text: $textValue, axis: .vertical)
                        .onChange(of: textValue) { newValue in
                            isTextFieldEmpty = newValue.isEmpty
                        }
                        .multilineTextAlignment(.leading)
                        .opacity(isEditing ? 0.5 : 1)
                        .padding(.horizontal, 15)
                }
                else {
                    HStack {
                        Text(data.wrappedAnswer.answerDetail)
                        Spacer()
                    }
                    .padding(.horizontal, 15)
                }
            }
            .padding(.all)
            
            if let commentDetail = data.answer?.comment,
               commentDetail != "" {
                HStack {
                    Spacer()
                    Text(commentDetail)
                        .padding(.all)
                        .background(
                            Rectangle()
                                .cornerRadius(20, corners: [.topLeft ,.topRight, .bottomLeft] )
                                .foregroundColor(.white)
                                .shadow(radius: 1)
                        )
                        .padding(.all, 16)
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
                .padding(.horizontal, 15)
                .padding(.bottom, 30)
            }
            
            
        }
    }
    
    var commentEditView: some View {
        ZStack {
            
            if data.answer?.comment == nil || data.answer?.comment == "" {
                Rectangle()
                    .frame(width: UIScreen.screenWidth-40, height: 40)
                    .cornerRadius(100)
                    .padding(.all)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                    .opacity(0.5)
                HStack {
                    TextField("나의 한 마디 작성하기", text: $commentTextField)
                        .padding(.leading, 40)
                        .onChange(of: commentTextField) { newValue in
                            isCommetFieldEmpty = newValue.isEmpty
                        }
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



//
//struct QnA_Previews: PreviewProvider {
//    static var previews: some View {
////        QnAView(isEditing: true, isTextFieldEmpty: true, isCommetFieldEmpty: true)
//    }
//}
