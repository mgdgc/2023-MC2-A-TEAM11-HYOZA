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
        sortDescriptors: [NSSortDescriptor(keyPath: \Question.timestamp, ascending:true)],
        predicate: .hasAnswer,
        animation: .default)
    
    private var items : FetchedResults<Question>
    @State private var searchText : String = ""
    @State private var answerText : String = "기본답변입니다."
    
    @Binding var isAnswered: Bool
    
    //코어데이터에서 호출하는 쿼리
    var query : Binding<String> {
        Binding {
            searchText
        } set : { newValue in
            searchText = newValue
            items.nsPredicate = newValue.isEmpty
            ? .hasAnswer
            : .hasAnswer && .contains(key: newValue)
        }
    }
    
    var body: some View {
        let viewWidth = UIScreen.main.bounds.size.width - 34
        NavigationView {
            ZStack{
                Color.backgroundColor.ignoresSafeArea(edges: .top)
                ScrollView{
                    LazyVStack {
                        //아이템을 만들어주기 위한 RoundedRectangle
                        ForEach(items) { item in
                            NavigationLink(destination : QnAView(data:item, isAnswered: $isAnswered, isEditing: false)){
                                CellContents(item : item)
                                    .cardify(backgroundColor: .white,
                                             cornerRadius: 15,
                                             shadowColor: .black.opacity(0.1),
                                             shadowRadius: 5,
                                             corners: .allCorners
                                           )
                                    .padding(.bottom, 20)

                            }
                        }
                    }
                }
            }
            .navigationTitle("질문 리스트")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarTitleTextColor(.textColor)
            .searchable(text: query,
                        placement: .navigationBarDrawer(displayMode: .automatic),
                        prompt: "검색")
            
        }
    }
}



//RoundedRectangle에 overlay 되는 텍스트
private struct CellContents : View {
    @ObservedObject var item : Question
    let viewWidth = UIScreen.main.bounds.size.width - 60
    // TODO: 더 나은 방식으로 개선할 수 없나?
    var body : some View{
        VStack(alignment : .leading) {
            Text(item.wrappedTimestamp, formatter : itemFormatter)
                .font(.subheadline)
                .bold()
                .foregroundColor(.textSecondaryColor)
                .padding(.bottom, 2)


            Text(item.wrappedQuestion)
                .bold()
                .font(.body)
                .padding(.bottom, 2)
            

            Text(item.wrappedAnswer.answerDetail)
                .font(.body)
                
                
        }
        .foregroundColor(.textColor)
        .multilineTextAlignment(.leading)
        .lineLimit(2)
        .padding(2)
        .frame(width: viewWidth, alignment: .leading)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 MM월 dd일"
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter
}()


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(isAnswered: .constant(false))
    }
}

