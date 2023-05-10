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
    
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    var body: some View {
        switch periodSelection {
        case .custom:
            VStack {
                datePicker("시작", selection: $startDate)
                datePicker("종료", selection: $endDate)
            }
        case .whole:
            VStack {
                datePicker("시작", selection: $startDate)
                datePicker("종료", selection: $endDate)
            }
            .disabled(true)
        default:
            EmptyView()
        }
        
    }
    
    func datePicker(_ titleKey: LocalizedStringKey, selection: Binding<Date>) -> some View {
        DatePicker(
            titleKey,
            selection: selection,
            displayedComponents: [.date]
        )
        .colorMultiply(Color.orange)
        .datePickerStyle(CompactDatePickerStyle())
        .environment(\.locale, Locale(identifier: "ko-KR"))
    }
}

struct PeriodView_Previews: PreviewProvider {
    static var previews: some View {
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
}
