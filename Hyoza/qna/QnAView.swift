//
//  QnAView.swift
//  Hyoza
//
//  Created by 조한동 on 2023/05/09.
//

import SwiftUI

struct QnAView: View {
    
    @State var isEditing: Bool = true
 
    @State var textValue = ""
    @State var commentTextField = ""
    @State var comment : String = ""
    @State var isComment : Bool = false
    @State private var showing = false
    @State var isTextFieldEmpty : Bool = true
    
    
    var body: some View {
        ZStack {
            Color(red: 255 / 255, green: 253 / 255, blue: 250 / 255)
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 15) {
                
                HStack{
                    
                    Button(action: {
                        showing = true
                        
                    }) {
                        
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.orange)
                    }
                    .alert(isPresented: $showing) {
                        Alert(
                            title: Text("이전 페이지로 이동 시,\n 작성하신 내용은 삭제됩니다."),
                            message: Text("그래도 나가시겠습니까?"),
                            primaryButton: .default(Text("머무르기")),
                            secondaryButton: .destructive(Text("나가기"))
                        )
                    }
                    
                    Spacer()
                    
                    Text("오늘의 질문")
                        
                    
                    Spacer()
                    
                    if isEditing {
                        Button(action: {
                            isEditing = false
                            commentTextField = ""
                        }) {
                            Text("완료")
                                .foregroundColor(isTextFieldEmpty ? .gray : .orange)
                        }
                    } else {
                       HStack {
                        Button(action: {
                            
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.orange)
                        }
                        .padding(.trailing)
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
                .padding(.bottom, 30)
                
                
                
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
                }
                
                Text("최근에 가장 재미있게 본 유튜브 영상은 무엇인가요?")
                    .font(.system(size: 25))
                    .padding(.leading, 30)
                
                Text("2023년 5월 5일")
                    .padding(.leading, 30)
                    .foregroundColor(.secondary)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .frame(height: 60)
                        .foregroundColor(.clear)
                    
                    if isEditing {
                        TextField("여기에 입력하세요", text: $textValue, axis: .vertical)
                            .onChange(of: textValue) { newValue in
                                isTextFieldEmpty = newValue.isEmpty
                            }
                            .multilineTextAlignment(.leading)
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
                            .opacity(isEditing ? 0.5 : 1)
                        
                    
                } else {
                    
                }
                
                
                
                Spacer()
                
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
    }
    func saveItem() {
       
        comment = commentTextField
        commentTextField = ""
    }
}

struct BeforeAnswerView_Previews: PreviewProvider {
    static var previews: some View {
        QnAView(isEditing: true)
    }
}
