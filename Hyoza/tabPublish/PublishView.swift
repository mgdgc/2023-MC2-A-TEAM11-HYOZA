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
    @State var segmentationSelection: PeriodSelection = .custom
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    let cornerRadius: CGFloat = 10
    
    var body: some View {
        ZStack {
            Color.backgroundColor
            VStack(alignment: .leading, spacing: .zero) {
                header
                PeriodSegmentView(selection: $segmentationSelection)
                periodView
                Spacer()
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
    
    var periodView: some View {
        CardView(shadowColor: .black.opacity(0.1)) {
            PeriodView(
                cornerRadius: cornerRadius,
            startDate: $startDate,
            endDate: $endDate
            )
        }
        .padding()
    
    }
}


struct PublishView_Previews: PreviewProvider {
    static var previews: some View {
        PublishView()
    }
}
