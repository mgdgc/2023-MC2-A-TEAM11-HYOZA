//
//  ListView.swift
//  Hyoza
//
//  Created by 최명근 on 2023/05/07.
//

import SwiftUI
import CoreData

struct ListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Question.timestamp, ascending: true)],
        animation: .default)
    
    private var items : FetchedResults<Question>

    
    var body: some View {
        NavigationView {
            ScrollView{
                LazyVStack {
                    header
//                    ForEach(items) { item in
                    ForEach(0..<100) { item in
                        RoundedRectangle(cornerRadius : 15)
                        //TODO : 프레임 스크린 넓이에서 가져오기
                            .frame(width: 350, height: 160)
                            .foregroundColor(.white)
                            .shadow( color : .gray, radius: 5, y :5)
                            .opacity(0.3)
                            .overlay{CellContents}
                            .padding(.bottom, 20)
                        
                    }
                  
                }
               
            }
        }
        
        
    }
    
    var header : some View {
        HStack {
            Text("질문 리스트")
                .font(.largeTitle)
                .bold()
            Spacer()
        }
        .padding(.leading, 20)
        .padding(.top, 43)
    }
    
    var CellContents : some View{
        // TODO : 더 나은 방식으로 개선할 수 없나?
        VStack(alignment : .leading) {
            Text("2023년 5월 5일")
                .font(.caption)
                .frame(width: 320, alignment: .leading)
                .lineLimit(1)
                .padding(.top, 15)
            
            Text("최근에 가장 재미있게 본 유튜브 영상은 무엇인가요?")
                .fontWeight(.bold)
                .font(.headline)
                .frame(width: 320, alignment: .leading)
                .lineLimit(2)
                .padding(.top, 5)
            
            Text("최근에 귀여운 강아지가 나오는 000 채널의 영상을 봤어요. 요새 동네들 산책하다보면 아주 귀여운 강아지가 ")
                .fontWeight(.regular)
                .font(.subheadline)
                .frame(width: 320, alignment: .leading)
                .lineLimit(2)
                .padding(.top, 5)
            Spacer()

        }
    }
}
    
    






struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
