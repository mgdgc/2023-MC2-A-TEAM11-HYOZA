//
//  PublishView.swift
//  Hyoza
//
//  Created by 최명근 on 2023/05/07.
//

import SwiftUI
import CoreData

struct PublishView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        ZStack {
            Color.backgroundColor
            VStack(alignment: .leading, spacing: .zero) {
                header
            }
        }
        .ignoresSafeArea(edges: .top)
        
    }
    
    var header: some View {
        HStack {
            Text("자서전 출판")
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color.textColor)
            Spacer()
        }
        .padding(.leading, 20)
        .padding(.top, 90)
    
    }
}

struct PublishView_Previews: PreviewProvider {
    static var previews: some View {
        PublishView()
    }
}
