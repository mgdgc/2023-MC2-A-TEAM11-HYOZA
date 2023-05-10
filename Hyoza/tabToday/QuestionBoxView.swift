//
//  QuestionBoxView.swift
//  Hyoza
//
//  Created by HAN GIBAEK on 2023/05/09.
//

import SwiftUI

struct QuestionBoxView: View {
    @Binding var zIndexQuestionBox: Double
    @Binding var zIndexQuestionCard: Double
    
    var body: some View {
        ZStack{
            Color.backGroundWhite
            VStack {
                Text("오늘의 질문 꾸러미")
                    .font(.title)
                Button(action: {
                    withAnimation(.easeInOut(duration: 2)){
                        zIndexQuestionBox = 0
                        zIndexQuestionCard = 1
                    }
                })
                {
                    Image(systemName: "shippingbox.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.backGroundLightOrange)
                        .padding(20)
                }
            }
        }
    }
}

struct QuestionBoxView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionBoxView(zIndexQuestionBox: .constant(1), zIndexQuestionCard: .constant(0))
    }
}
