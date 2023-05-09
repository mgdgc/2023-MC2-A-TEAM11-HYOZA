//
//  PeriodView.swift
//  Hyoza
//
//  Created by sei on 2023/05/08.
//

import SwiftUI

struct PeriodView: View {
    var cornerRadius: CGFloat
    
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    var body: some View {
        VStack {
            datePicker("시작", selection: $startDate)
            datePicker("종료", selection: $endDate)
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
//        .tint(Color.cardSecondaryColor)
        .environment(\.locale, Locale(identifier: "ko-KR"))
    }
}

struct PeriodView_Previews: PreviewProvider {
    static var previews: some View {
        PeriodView(cornerRadius: 10, startDate: .constant(Date()), endDate: .constant(Date()))
    }
}
