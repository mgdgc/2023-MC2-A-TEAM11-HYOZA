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
    
    @State private var titleText = ""
    @State private var periodSelection: PeriodSelection = .custom
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var selectedMonth: Month = .may
    @State private var selectedYear: Int = (PersistenceController.shared.oldestAnsweredQuestion?.timestamp ?? Date()).year
    
    
    private enum K {
        static let cornerRadius: CGFloat = 10
        static let title: String = "출판하기"
        static let leadingPadding: CGFloat = 20
        static let topPadding: CGFloat = 90
        static let textFieldTitle: String = "제목을 입력해 주세요."
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
    
    
    private var header: some View {
        HStack {
            Text(K.title)
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color.textColor)
            Spacer()
        }
        .padding(.top, K.topPadding)
    }
    
    
    private func segmentedSelectionDidChange(newValue: PeriodSelection) {
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
    
    private var titleTextField: some View {
        TextField(K.textFieldTitle, text: $titleText)
            .background(.white)
            .cornerRadius(K.cornerRadius)
            .publishCardify()
    }
    
    private var periodView: some View {
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
    
    private func fetchAfterDateChanged() {
        withAnimation {
            questions.nsPredicate = .hasAnswer && .timestampIn(between: startDate, and: endDate)
        }
    }
    
    private var countLabel: some View {
        Text(K.countLabel(questions.count))
            .font(.callout)
            .foregroundColor(.gray)
    }
    
    // ShareSheet를 열기 위한 변수로 사용하기 위해 Identifiable을 구현한 Wrapper
    private struct PDFWrapper: Identifiable {
        var id: UUID = UUID()
        var url: URL = FileManager.default.temporaryDirectory
    }
    
    // ShareSheet로 공유할 데이터
    @State private var pdfToShare: PDFWrapper? = nil
}

extension PublishView {
    private var publishButton: some View {
        ButtonView (
            buttonColor: (questions.isEmpty || titleText.isEmpty) ? .textThirdColor : .buttonColor,
            content: K.publishButtonTitle,
            action: shareToPdf
        )
        .sheet(item: $pdfToShare) { data in
            ActivityViewControllerWrapper(items: [data.url], activities: [])
        }
        .padding(.vertical, 20)
        .padding(.bottom, 20)
        .disabled(questions.isEmpty || titleText.isEmpty)
    }
    
    private func shareToPdf() {
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
        
        let fileName = "\(titleText)_\(Date().numberOnlyString).pdf"
        let pdfURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        // PDF 공유
        pdfToShare = PDFWrapper(
            url:pdfURL
        )
        
        do {
            try pdfData.write(to: pdfToShare?.url ?? pdfURL)
        } catch {
            print(error)
        }
    }
}
