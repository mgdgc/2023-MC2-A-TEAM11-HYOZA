//
//  PeriodView.swift
//  Hyoza
//
//  Created by sei on 2023/05/08.
//

import SwiftUI

struct PeriodView: View {
    var cornerRadius: CGFloat
    var periodSelection: PeriodSelection
    var firstDate = PersistenceController.shared.oldestAnsweredQuestion?.answer?.answerTime ?? Date()
    private enum K {
        static let startText: LocalizedStringKey = "시작"
        static let endText: LocalizedStringKey = "종료"
        static let pickerLocale: String = "ko-KR"
    }
    
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    
    var body: some View {
        VStack {
            Group {
                DatePicker(
                    K.startText,
                    selection: $startDate,
                    in: firstDate...endDate,
                    displayedComponents: [.date]
                )
                
                DatePicker(
                    K.endText,
                    selection: $endDate,
                    in: startDate...Date(),
                    displayedComponents: [.date]
                )
            }
            .foregroundColor(.textColor)
            .colorMultiply(Color.orange)
            .datePickerStyle(CompactDatePickerStyle())
            .environment(\.locale, Locale(identifier: K.pickerLocale))
        }
        .disabled(periodSelection == .whole)
    }
}

struct PeriodView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PeriodView(cornerRadius: 10,
                       periodSelection: .custom,
                       startDate: .constant(Date()),
                       endDate: .constant(Date())
            )
            PeriodView(
                cornerRadius: 10,
                periodSelection: .whole,
                startDate: .constant(Date()),
                endDate: .constant(Date())
            )
        }
        .previewLayout(.fixed(width: 300, height: 100))
    }
}
