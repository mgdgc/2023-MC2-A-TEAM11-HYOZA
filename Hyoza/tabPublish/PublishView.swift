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
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Question.timestamp, ascending:false)],
        predicate: .hasAnswer,
        animation: .default)
    private var questions: FetchedResults<Question>
    
    @State var titleText = ""
    @State var periodSelection: PeriodSelection = .custom
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var selectedMonth: Month = .may
    @State var selectedYear: Int = (PersistenceController.shared.oldestAnsweredQuestion?.timestamp ?? Date()).year
    
    
    enum K {
        static let cornerRadius: CGFloat = 10
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
                        .padding(.top, 4)
                    PeriodSegmentView(selection: $periodSelection)
                        .onChange(
                            of: periodSelection,
                            perform: segmentedSelectionDidChange
                        )
                    periodView
                        .offset(.init(width: 0, height: -8))
                    titleTextField
                        .offset(.init(width: 0, height: -16))
                    Spacer()
                    ResultBookView(count: questions.count, title: titleText)
                        .padding()
                    countLabel
                    publishButton
                }
                .padding(.horizontal, K.leadingPadding)
            
        }
        .ignoresSafeArea(edges: .top)
        .onAppear {
            questions.nsPredicate = .hasAnswer && .timestampIn(between: startDate, and: endDate)
        }
    }
    

    var header: some View {
        HStack {
            Text(K.title)
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color.textColor)
            Spacer()
        }
//        .padding(.leading, K.leadingPadding)
        .padding(.top, K.topPadding)
    }
    
    
    func segmentedSelectionDidChange(newValue: PeriodSelection) {
        switch newValue {
        case .custom:
            startDate = Date().start
            endDate = Date().end
        case .oneMonth:
            startDate = selectedMonth.start
            endDate = selectedMonth.end
        case .whole:
            startDate = (PersistenceController.shared.oldestAnsweredQuestion?.answer?.answerTime ?? Date()).start
            endDate = (PersistenceController.shared.latestAnsweredQuestion?.answer?.answerTime ?? Date()).end
        }
        fetchAfterDateChanged()
    }
    
    var titleTextField: some View {
        TextField(K.textFieldTitle, text: $titleText)
            .background(.white)
            .cornerRadius(K.cornerRadius)
            .publishCardify()
    }
    
    var periodView: some View {
        ZStack(alignment: .top) {
            PeriodView(
                cornerRadius: K.cornerRadius,
                periodSelection: periodSelection,
                startDate: $startDate,
                endDate: $endDate
            )
            .publishCardify()
            .opacity(periodSelection == .oneMonth ? 0 : 1)
            .onChange(of: startDate) { _ in fetchAfterDateChanged() }
            .onChange(of: endDate) { _ in fetchAfterDateChanged() }
            
            MonthPickerView(startYear: 2023, selectedYear: $selectedYear, selectedMonth: $selectedMonth)
                .publishCardify()
                .opacity(periodSelection == .oneMonth ? 1 : 0)
                .onChange(of: selectedMonth) { _ in
                    startDate = selectedMonth.start
                    endDate = selectedMonth.end
                    fetchAfterDateChanged()
                }
        }
    }
    
    func fetchAfterDateChanged() {
        withAnimation {
            questions.nsPredicate = .hasAnswer && .timestampIn(between: startDate, and: endDate)
        }
    }
    
    var countLabel: some View {
        Text(K.countLabel(questions.count))
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
}

extension PublishView {
    
    var publishButton: some View {
            ButtonView (content: K.publishButtonTitle) {
                
                // 질문과 답변을 PDF Text로 변환
                var pdfTexts: [PDFText] = []
                
                pdfTexts.append(PDFText(string: titleText, attributes: PDFTextStyle.title, alignment: .center, indent: 0, spacing: .title))
                
                for item in questions {
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
            }
//            Button {
//
//            } label: {
//                ZStack {
//                    questions.isEmpty ? Color.textThirdColor : Color.buttonColor
//                    Text(K.publishButtonTitle)
//                        .foregroundColor(.buttonTextColor)
//                        .bold()
//                }
//                .frame(width: UIScreen.screenWidth * 0.8, height: 57)
//                .cornerRadius(50)
//            }
//            .disabled(questions.isEmpty)
//            .sheet(item: $pdfToShare) { data in
//                ActivityViewControllerWrapper(items: [data.data], activities: [])
//            }
//            Spacer()
        .padding()
    }
}

//struct PublishView_Previews: PreviewProvider {
//    static var previews: some View {
//        PublishView()
//    }
//}
