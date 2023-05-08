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
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Question.timestamp, ascending: true)],
//        animation: .default)
    
    private var items : FetchedResults<Question>

    
    var body: some View {
        NavigationView {
            ScrollView{
                LazyVStack {
                    header
//                    ForEach(items) { item in
                        
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
        .padding(.top, 50)
    }
    
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
