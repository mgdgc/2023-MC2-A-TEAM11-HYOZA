//
//  MonthPicker.swift
//  Hyoza
//
//  Created by sei on 2023/05/09.
//

import SwiftUI

enum Month: Int, CaseIterable, Identifiable {
    case jan = 1, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
    var id: Self { self }
}

struct MonthPickerView: View {
    @Binding var selectedMonth: Month
    var body: some View {
        HStack {
            Text("월")
            Spacer()
            Picker("Month", selection: $selectedMonth) {
                ForEach(Month.allCases) { Text("\($0.rawValue)월") }
            }
            .pickerStyle(.menu)
        }
        
    }
}

struct MonthPicker_Previews: PreviewProvider {
    static var previews: some View {
        MonthPickerView(selectedMonth: .constant(.apr))
    }
}
