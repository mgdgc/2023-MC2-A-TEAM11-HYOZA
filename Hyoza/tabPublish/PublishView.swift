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
    
    enum K {
        static let title: String = "자서전 출판"
        static let leadingPadding: CGFloat = 20
        static let topPadding: CGFloat = 90
        static let textFieldTitle: String = "제목"
        static func countLabel(_ count: Int) -> String {
            "\(count)개의 질문"
        }
        static let publishButtonTitle: String = "출판하기"
    }
    
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
                Spacer()
                ResultBookView(count: count, title: titleText)
                    .padding()
                countLabel
                publishButton
            }
        }
        .ignoresSafeArea(edges: .top)
    }
    
    var header: some View {
        HStack {
            Text(K.title)
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color.textColor)
            Spacer()
        }
        .padding(.leading, K.leadingPadding)
        .padding(.top, K.topPadding)
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
        TextField(K.textFieldTitle, text: $titleText)
            .background(.white)
            .cornerRadius(cornerRadius)
            .publishCardify()
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
        Text(K.countLabel(count))
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
                    Text(K.publishButtonTitle)
                        .foregroundColor(Color.buttonTextColor)
                        .bold()
                }
                .frame(width: UIScreen.screenWidth * 0.8, height: 57)
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
