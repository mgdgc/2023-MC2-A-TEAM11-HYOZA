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
        sortDescriptors: [NSSortDescriptor(keyPath: \Question.timestamp, ascending:false)],
        animation: .default)
    
    private var items : FetchedResults<Question>
    
    
    var body: some View {
        ScrollView{
            LazyVStack {
                    header
                //MARK: 삭제예정 : 코어데이터 생성을 위해 임의 배치
                Button(action : addItem){
                    Label("Add Item", systemImage: "plus")
                }
                //MARK: 삭제예정 :코어데이터 생성을 위해 임의 배치
                ForEach(items) { item in
                    RoundedRectangle(cornerRadius : 15)
                    //TODO: 프레임 스크린 넓이에서 가져오기
                        .frame(width: 350, height: 160)
                        .foregroundColor(.white)
                        .shadow( color : .gray, radius: 5, y :5)
                        .opacity(0.3)
                        .overlay(CellContents(item : item))
                        .padding(.bottom, 20)
                    
                }
            }
        }
    }

    
    // MARK: 삭제예정 :데이터가 들어오면 삭제될 부분
    private func addItem() {
        withAnimation {
            let newItem = Question(context: managedObjectContext)
            newItem.id = Int64(Int(UUID().hashValue))
            newItem.answer = "일기가 추가될 때, 일기를 특정할 수 있게 일기의 고유한 값을 저장하게 해야함, 즐겨찾기, 수정, 삭제 할때, 이 일기의 고유의 값을 전달할 수 있게 해야함, 전달받은 쪽에서 일기의 고유한 값이 있는지 확인하고 고유한 값에 해당되는 인덱스로 수정, 삭제, 즐겨찾기, 상태 업데이트를 구현 해줘야 함 위해"
            newItem.answerTime = Date()
            newItem.comment = "코멘트코멘트"
            newItem.difficulty = 2
            newItem.question = "일기가 추가될 때, 일기를 특정할 수 있게 일기의 고유한 값을 저장하게 해야함,"
            newItem.timestamp = Date()
            
            do {
                try managedObjectContext.save()
            }catch{
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    //MARK: 삭제예정 :데이터가 들어오면 삭제될 부분
}

private var header : some View {
    HStack {
        Text("질문 리스트")
            .font(.largeTitle)
            .bold()
        Spacer()
    }
    .padding(.leading, 20)
    .padding(.top, 43)
}

private struct CellContents : View {
    
    @State private var appear = false
    var item : Question
    // TODO: 더 나은 방식으로 개선할 수 없나?
    var body : some View{
        VStack(alignment : .leading) {
            Text(item.timestamp!, formatter : itemFormatter)
                .font(.caption)
                .frame(width: 320, alignment: .leading)
                .lineLimit(1)
                .padding(.top, 15)
            
            Text(item.question!)
                .fontWeight(.bold)
                .font(.headline)
                .frame(width: 320, alignment: .leading)
                .lineLimit(2)
                .padding(.top, 5)
            
            Text(item.answer!)
                .fontWeight(.regular)
                .font(.subheadline)
                .frame(width: 320, alignment: .leading)
                .lineLimit(2)
                .padding(.top, 5)
            Spacer()
            
        }
    }
}
  
private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "yyyy년 MM월 dd일"
//    formatter.locale = Locale(identifier: "ko_KR")
//    return formatter
    //MARK: 삭제예정 : 다른점을 보기 위한 타임스탬프
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
    //MARK: 삭제예정 : 다른점을 보기 위한 타임스탬프
}()
    
    
struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

