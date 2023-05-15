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
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Question.timestamp, ascending:false)],
        animation: .default)
    private var items: FetchedResults<Question>
    @State var count: Int = 0
    
    
    var fromDate: Binding<Date> {
        Binding {
            startDate
        } set: { newValue in
            startDate = newValue
            items.nsPredicate = NSPredicate(
                format: "timestamp >= %@ AND timestamp < %@",
                Calendar.current.startOfDay(for: startDate) as NSDate,
                Calendar.current.startOfDay(for: endDate) as NSDate)
            count = items.count
        }
    }
    
    var toDate: Binding<Date> {
        Binding {
            endDate
        } set: { newValue in
            endDate = newValue
            items.nsPredicate = NSPredicate(
                format: "timestamp >= %@ AND timestamp < %@",
                Calendar.current.startOfDay(for: startDate) as NSDate,
                Calendar.current.startOfDay(for: endDate) as NSDate)
            count = items.count
        }
    }
    
    @State var titleText = ""
    @State var periodSelection: PeriodSelection = .custom
    
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var selectedMonth: Month = .may
    
    let cornerRadius: CGFloat = 10
    
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
                startDate: fromDate,
                endDate: toDate
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
    
    // ShareSheet를 열기 위한 변수로 사용하기 위해 Identifiable을 구현한 Wrapper
    struct PDFWrapper: Identifiable {
        var id: UUID = UUID()
        var data: Data
    }
    
    // ShareSheet로 공유할 데이터
    @State private var pdfToShare: PDFWrapper? = nil
    
    var publishButton: some View {
        HStack {
            Spacer()
            Button {
                
                // 질문과 답변을 PDF Text로 변환
                var pdfTexts: [PDFText] = []
                
                pdfTexts.append(PDFText(string: titleText, attributes: PDFTextStyle.title, alignment: .center, indent: 0, spacing: .title))
                
                for item in items {
                    pdfTexts.append(PDFText(string: item.wrappedQuestion, attributes: PDFTextStyle.question, alignment: .left, spacing: .question))
                    
                    if let answer = item.answer?.answer, let date = item.answer?.answerTime {
                        pdfTexts.append(PDFText(string: answer, attributes: PDFTextStyle.answer, alignment: .left, spacing: .answer))
                        pdfTexts.append(PDFText(string: date.fullString, attributes: PDFTextStyle.date, alignment: .left, spacing: .date))
                    }
                    
                    if let comment = item.answer?.comment {
                        pdfTexts.append(PDFText(string: comment, attributes: PDFTextStyle.comment, alignment: .left, spacing: .comment))
                    }
                }
                
                // PDF Text를 PDF로 변환
                let generator = PDFGenerator()
                let pdfData = generator.generatePDF(title: titleText, texts: pdfTexts)
                
                // PDF 공유
                pdfToShare = PDFWrapper(data: pdfData)
                
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
            .sheet(item: $pdfToShare) { data in
                ActivityViewControllerWrapper(items: [data.data], activities: [])
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
