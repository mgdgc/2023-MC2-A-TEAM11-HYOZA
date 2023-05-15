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
        predicate: .hasAnswer,
        animation: .default)
    
    private var items : FetchedResults<Question>
    @State private var searchText : String = ""
    @State private var answerText : String = "기본답변입니다."
    
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
        NavigationView {
            ZStack{
                ScrollView{
                    LazyVStack(spacing: 20) {
                        //MARK: 삭제예정 :코어데이터 생성을 위해 임의 배치
                        //아이템을 만들어주기 위한 RoundedRectangle
                        ForEach(items) { item in
                            NavigationLink(destination : QnAView(data:item, isEditing: false)){
                                CardView(shadowColor: Color.black.opacity(0.1)) {
                                    CellContents(item : item)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 4)
                                }
                                .padding([.leading, .trailing], 20)
                            }
                        }
                    }.padding(.top, 4)
                }
            }
            .background(Color.backgroundColor.ignoresSafeArea())
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
    // TODO: 더 나은 방식으로 개선할 수 없나?
    var body : some View{
        VStack(alignment : .leading, spacing: 8) {
            HStack {
                Text(item.wrappedTimestamp, formatter : itemFormatter)
                    .font(.subheadline)
                    .foregroundColor(.tapBarDarkGray)
                    .lineLimit(1)
                Spacer()
            }
            
            Text(item.wrappedQuestion)
                .font(.body.bold())
                .foregroundColor(.textBlack)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            
            Text(item.wrappedAnswer.answerDetail)
                .font(.body)
                .foregroundColor(.textBlack)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .foregroundColor(.textColor)
        .multilineTextAlignment(.leading)
        .lineLimit(2)
        .padding(2)
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
        ListView()
    }
}

