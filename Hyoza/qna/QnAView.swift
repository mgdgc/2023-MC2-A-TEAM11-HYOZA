//
//  QnAView.swift
//  Hyoza
//
//  Created by 조한동 on 2023/05/09.
//

import SwiftUI

struct ImageWrapper: Identifiable {
    var id: UUID = UUID()
    var image: UIImage
}

struct QnAView: View {
    
    var data: FetchedResults<Question>.Element? = nil
    
    @State var isEditing: Bool = true
    @State var textValue = ""
    @State var commentTextField = ""
    @State var comment : String = ""
    @State var isComment : Bool = false
    @State private var showingAlert = false
    @State var isTextFieldEmpty : Bool = true
    
//    @State var navigateToPreviousView = false
//    //navigateToPreviousView가 True이면 이전 뷰로 되돌아 감.
    
    @State private var imageToShare: ImageWrapper? = nil
    
    @Environment(\.displayScale) var displayScale
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 15) {
                
                topView
                
                
                
                contentView
                
                
                Spacer()
                
                
                commentEditView
                
            }
            
        }
    }
    
    
    func saveItem() {
        
        comment = commentTextField
        commentTextField = ""
    }
    
    var topView: some View {
        HStack{
            
            Button(action: {
                showingAlert = true
                
//                if let data = data {
//                    
//                    // 값 변경 혹은 저장 혹은 수정
//                    data.answer = textValue
//                    
//                    do {
//                        try managedObjectContext.save()
//                    } catch {
//                        print(#function, error)
//                    }
//                }
                
            }) {
                
                Image(systemName: "chevron.backward")
                    .foregroundColor(.orange)
            }
            .alert(isPresented: $showingAlert) {
                let stayButton = Alert.Button.default(Text("머무르기")) {
                    // 머무르기 버튼 눌렀을 때 발생할 이벤트
                }
                let exitButton = Alert.Button.destructive(Text("나가기")) {
//                    navigateToPreviousView = true
                    // 나가기 버튼 눌렀을 때 발생할 이벤트
                }
                return Alert(title: Text("이전 페이지로 이동 시,\n 작성하신 내용은 삭제됩니다."), message: Text("그래도 나가시겠습니까?"), primaryButton: stayButton, secondaryButton: exitButton)
                
            }
            
            Spacer()
            
            if isEditing {
                Text("오늘의 질문")
                    .padding(.leading, 15)
            } else {
                Text("오늘의 질문")
                    .padding(.leading, 45)
            }
            
            
            
            Spacer()
            
            if isEditing {
                Button(action: {
                    if !isTextFieldEmpty {
                        isEditing = false
                        commentTextField = ""
                    } else {
                        print("텍스트를 입력해주세요.")
                    }
                    
                }) {
                    Text("완료")
                        .foregroundColor(isTextFieldEmpty ? .gray : .orange)
                    
                }
            } else {
                HStack {
                    Button(action: {
                        Task {
                            var answerBackup = textValue
                            var commentBackup = comment
                            
                            for i in 0..<textValue.count {
                                if i % 60 == 0 {
                                    textValue.insert("\n", at: textValue.index(textValue.startIndex, offsetBy: i))
                                }
                            }
                            
                            for i in 0..<comment.count {
                                if i % 60 == 0 {
                                    comment.insert("\n", at: comment.index(comment.startIndex, offsetBy: i))
                                }
                            }
                            
                            guard let image = await contentView.render(scale: displayScale) else {
                                return
                            }
                            
                            imageToShare = ImageWrapper(image: image)
                            
                            textValue = answerBackup
                            comment = commentBackup
                        }
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.orange)
                    }
                    .padding(.trailing)
                    .sheet(item: $imageToShare) { imageToShare in
                        ActivityViewControllerWrapper(items: [imageToShare.image], activities: nil)
                    }
                    
                    Button(action: {
                        isEditing = true
                        commentTextField = comment
                        
                        
                    }) {
                        Image(systemName: "pencil")
                            .foregroundColor(.orange)
                    } }
            }
            
        }
        .padding(.horizontal, 25)
    
        
    }
    
    var contentView: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack{
                Rectangle()
                
                    .frame(width: 50, height: 30)
                    .cornerRadius(30)
                
                    .foregroundColor(.orange)
                    .opacity(0.2)
                    .overlay(
                        Text("쉬움")
                            .foregroundColor(.orange)
                    )
                    .padding(.leading, 30)
                    .padding(.top, 30)
            }
            
            Text("최근에 가장 재미있게 본 유튜브 영상은 무엇인가요?")
                .font(.system(size: 25))
                .padding(.horizontal, 30)
            
            Text("2023년 5월 5일")
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
                        Text(textValue)
                        Spacer()
                    }
                    .padding(.horizontal, 15)
                }
            }
            
            .padding(.all)
            
            if isComment {
                HStack {
                    Spacer()
                    Text(comment)
                        .padding(.all)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.white)
                                .shadow(radius: 1)
                            
                        )
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 30)
                .opacity(isEditing ? 0.5 : 1)
                
                
            } else {
                
            }
            
        }
        
    }
    
    
    
    
    var commentEditView: some View {
        ZStack {
            Rectangle()
                .frame(width: .infinity, height: 40)
                .cornerRadius(100)
                .padding(.all)
                .foregroundColor(.white)
                .shadow(radius: 5)
                .opacity(0.5)
            
            
            
            HStack {
                TextField("나의 한 마디 작성하기", text: $commentTextField)
                    .padding(.leading, 40)
                
                Button(action: {
                    saveItem()
                    isComment = true
                }) {
                    Text("게시")
                        .foregroundColor(.orange)
                }
                .padding(.trailing, 35)
            }
        }
    }
}

struct BeforeAnswerView_Previews: PreviewProvider {
    static var previews: some View {
        QnAView(isEditing: true)
    }
}
