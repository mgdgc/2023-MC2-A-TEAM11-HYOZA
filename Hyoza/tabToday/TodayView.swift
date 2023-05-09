//
//  TodayView.swift
//  Hyoza
//
//  Created by 최명근 on 2023/05/07.
//

import SwiftUI
import CoreData

struct TodayView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var isQuestionBoxOpen: Bool = false
    @State var zIndexQuestionBox: Double = 1
    @State var zIndexClosedQuestions: Double = 0
    @State var zIndexOpenQuestionCard: Double = 0
    
    var body: some View {
        ZStack {
            Color.backGroundWhite
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 20) {
                Text("5월 5일 금요일")
                    .font(.system(.footnote))
                HStack {
                    Text("오늘의 질문")
                        .font(.largeTitle)
                    Spacer()
                    Image(systemName: "flame.fill")
                    Text("+12")
                }
                Spacer()
                ZStack {
                    CardView(cornerRadius: 16, shadowColor: .black.opacity(0.05), shadowRadius: 12) {
                        QuestionBoxView(zIndexQuestionBox: $zIndexQuestionBox, zIndexClosedQuestions: $zIndexClosedQuestions)
                    }
                    .zIndex(zIndexQuestionBox)
                    CardView(cornerRadius: 16, shadowColor: .black.opacity(0.05), shadowRadius: 12) {
                        ClosedQuestionsView()
                    }
                    .zIndex(zIndexClosedQuestions)
//                    CardView(cornerRadius: 16, shadowColor: .black.opacity(0.05), shadowRadius: 12) {
//                        QuestionBoxView(zIndexQuestionBox: $zIndexQuestionBox, zIndexClosedQuestions: $zIndexOpenQuestionCard)
//                    }
//                    .zIndex(zIndexOpenQuestionCard)
                    //                    Image("sampleQuestionCard")
                    //                        .resizable()
                    //                        .scaledToFit()
                }
                Spacer()
            }
            .padding(20)
            
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
