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
    
    @State var isQuestionBoxViewTapped: Bool = false
    
    @State var openDegree: Double = 90
    @State var closedDegree: Double = 0
    
    @State var easyQuestions: [QuerySentence] = QuerySentenceManager.shared.filtered(difficulty: .easy)
    @State var hardQuestions: [QuerySentence] = QuerySentenceManager.shared.filtered(difficulty: .hard)
    @State var isContinueIconShrunk: Bool = false
    
    var body: some View {
        ZStack {
            Color.backGroundWhite
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 20) {
                Text(Date().dateOnlyString)
                    .font(.system(.footnote))
                HStack {
                    Text("오늘의 질문")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.textBlack)
                    Spacer()
                    Image(systemName: "flame.fill")
                    Text("+12")
                }
                Spacer()
                ZStack {
                    if isQuestionBoxViewTapped {
                        CardView(cornerRadius: 16, shadowColor: .black.opacity(0.05), shadowRadius: 12) {
                            QuestionCardView(openDegree: $openDegree, closedDegree: $closedDegree,  easyQuestions: $easyQuestions, hardQuestions: $hardQuestions)
                        }
                    } else {
                        CardView(cornerRadius: 16, shadowColor: .black.opacity(0.05), shadowRadius: 12) {
                            QuestionBoxView(easyQuestions: $easyQuestions, hardQuestions: $hardQuestions, isQuestionBoxViewTapped: $isQuestionBoxViewTapped)
                        }
                        .onTapGesture {
                            self.isQuestionBoxViewTapped.toggle()
                        }
                    }
                    
                }
                Spacer()
            }
            .padding(20)
            
        }
        .onAppear() {
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                
            }
        }
    }
}

struct ContinueIconView: View {
    var body: some View {
        HStack {
            Image(systemName: "flame.fill")
            Text("+12")
        }
        
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
