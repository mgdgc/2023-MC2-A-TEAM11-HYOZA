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
    @State private var searchText : String = ""
    //코어데이터에서 호출하는 쿼리
    var query : Binding<String> {
        Binding {
            searchText
        } set : { newValue in
            searchText = newValue
            items.nsPredicate = newValue.isEmpty
            ? nil
            : NSPredicate(format : "answer CONTAINS[cd] %@ OR question CONTAINS[cd] %@ ", newValue, newValue)
        }
    }
    
    var body: some View {
        let viewWidth = UIScreen.main.bounds.size.width - 40
        NavigationView {
            ZStack{
                Color.backgroundColor.ignoresSafeArea(edges: .top)
                ScrollView{
                    LazyVStack {
                        //MARK: 삭제예정 : 코어데이터 생성을 위해 임의 배치
                        Button(action : addItem1){
                            Label("Add Item1", systemImage: "plus")
                        }
                        Button(action : addItem2){
                            Label("Add Item2", systemImage: "plus")
                        }
                        Button(action : addItem3){
                            Label("Add Item3", systemImage: "plus")
                        }
                        //MARK: 삭제예정 :코어데이터 생성을 위해 임의 배치
                        //아이템을 만들어주기 위한 RoundedRectangle
                        ForEach(items) { item in
                            NavigationLink(destination : QnAView(textValue: item.question!, comment: item.comment!)){
                                RoundedRectangle(cornerRadius : 15)
                                    .frame(width: viewWidth, height: 160)
                                    .foregroundColor(.white)
                                    .shadow( color : .gray, radius: 5, y :5)
                                    .opacity(0.3)
                                    .overlay(CellContents(item : item))
                                    .padding(.bottom, 20)
                            }
                            
                        }
                    }
                }
            }
            .navigationTitle("질문 리스트")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarTitleTextColor(.textColor)
        }
        .searchable(text: query,
                    placement: .navigationBarDrawer(displayMode: .automatic),
                    prompt: "검색")
    }
    
    // MARK: 삭제예정 :데이터가 들어오면 삭제될 부분
    private func addItem1() {
        withAnimation {
            let newItem1 = Question(context: managedObjectContext)
            newItem1.id = Int64(Int(UUID().hashValue))
            newItem1.answer = "엄마엄마엄마엄마엄마엄마엄마엄마엄마엄마엄마엄마엄마엄마엄마엄마"
            newItem1.answerTime = Date()
            newItem1.comment = "아빠아빠아빠"
            newItem1.difficulty = 2
            newItem1.question = "동생동생동생동생동생동생동생동생동생동생동생동생동생동생동생동생동생동생"
            newItem1.timestamp = Date()
            
            do {
                try managedObjectContext.save()
            }catch{
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    private func addItem2() {
        withAnimation {
            
            let newItem2 = Question(context: managedObjectContext)
            newItem2.id = Int64(Int(UUID().hashValue))
            newItem2.answer = "나비나비나비나비나비나비나비나비나비나비나비나비나비나비나비나비나비나비나비나비"
            newItem2.answerTime = Date()
            newItem2.comment = "꽃꽃꽃"
            newItem2.difficulty = 2
            newItem2.question = "강아지강아지강아지강아지강아지강아지강아지아지강아지강아지강아강아지강아지강아지"
            newItem2.timestamp = Date()
            
            do {
                try managedObjectContext.save()
            }catch{
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    private func addItem3() {
        withAnimation {
            
            let newItem3 = Question(context: managedObjectContext)
            newItem3.id = Int64(Int(UUID().hashValue))
            newItem3.answer = "고양이고양이고양이고양이고양이고양이고양이고양이고양이고양이"
            newItem3.answerTime = Date()
            newItem3.comment = "동글이동글이"
            newItem3.difficulty = 2
            newItem3.question = "산타산타산타산타산타산타산타산타산타산타산타산타산타산타산타산타산타산타"
            newItem3.timestamp = Date()
            
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



//RoundedRectangle에 overlay 되는 텍스트
private struct CellContents : View {
    var item : Question
    let viewWidth = UIScreen.main.bounds.size.width - 60
    // TODO: 더 나은 방식으로 개선할 수 없나?
    var body : some View{
        VStack(alignment : .leading) {
            Text(item.timestamp!, formatter : itemFormatter)
                .font(.caption)
                .foregroundColor(.textColor)
                .frame(width: viewWidth , alignment: .leading)
                .lineLimit(1)
                .padding(.top, 15)
            
            Text(item.question!)
                .fontWeight(.bold)
                .font(.headline)
                .foregroundColor(.textColor)
                .frame(width: viewWidth, alignment: .leading)
                .lineLimit(2)
                .padding(.top, 5)
            
            Text(item.answer!)
                .fontWeight(.regular)
                .font(.subheadline)
                .foregroundColor(.textColor)
                .frame(width: viewWidth, alignment: .leading)
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

