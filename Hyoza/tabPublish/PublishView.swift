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
    
    @State var titleText = ""
    @State var periodSelection: PeriodSelection = .custom
    
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var selectedMonth: Month = .may
    
    let cornerRadius: CGFloat = 10
    var count: Int { 10 }
    
    var body: some View {
        ZStack {
            Color.backgroundColor
            VStack(alignment: .center, spacing: .zero) {
                header
                PeriodSegmentView(selection: $periodSelection)
                    .onChange(
                        of: periodSelection,
                        perform: segmentedSelectionDidChange
                    )
                titleTextField
                periodView
                ResultBookView(count: count, title: titleText)
                    .padding()
                countLabel
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
    
    func segmentedSelectionDidChange(newValue: PeriodSelection) {
        switch newValue {
        case .custom:
            startDate = Date()
            endDate = Date()
        case .oneMonth:
            print("oneMonth")
        case .whole:
            startDate = Date() - 130
            endDate = Date() - 10
        }
    }
    
    var titleTextField: some View {
        CardView(shadowColor: .black.opacity(0.1)) {
            TextField("제목", text: $titleText)
                .background(.white)
                .cornerRadius(cornerRadius)
        }
        .padding()
    }
    
    var periodView: some View {
        ZStack(alignment: .top) {
            PeriodView(
                cornerRadius: cornerRadius,
                periodSelection: periodSelection,
                startDate: $startDate,
                endDate: $endDate
            )
                .publishCardify()
                .opacity(periodSelection == .oneMonth ? 0 : 1)
            MonthPickerView(selectedMonth: $selectedMonth)
                .publishCardify()
                .opacity(periodSelection == .oneMonth ? 1 : 0)
        }
    }
    
    var countLabel: some View {
        Text("\(count)개의 질문")
            .font(.callout)
            .foregroundColor(.gray)
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
