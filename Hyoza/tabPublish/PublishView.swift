//
//  PublishView.swift
//  Hyoza
//
//  Created by 최명근 on 2023/05/07.
//

import SwiftUI
import UIKit
import CoreData

struct PublishView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.displayScale) var displayScale
    @State var text = ""
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
                titleTextField
                periodView
                Spacer()
                publishButton
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
    
    var titleTextField: some View {
        CardView(shadowColor: .black.opacity(0.1)) {
            TextField("제목", text: $text)
                .background(.white)
                .cornerRadius(cornerRadius)
        }
        .padding()
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
    
    var publishButton: some View {
        HStack {
            Spacer()
            Button {
                print("출판하기 button did tap")
                Task {
                    if let image = await periodView.render(scale: displayScale) {
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    }
                }
            } label: {
                ZStack {
                    Color.buttonColor
                    Text("출판하기")
                        .foregroundColor(Color.buttonTextColor)
                        .bold()
                }
                .frame(width: 310, height: 57)
                .cornerRadius(50)
            }
            Spacer()
        }
        .padding()
    }
}


struct PublishView_Previews: PreviewProvider {
    static var previews: some View {
        PublishView()
    }
}
