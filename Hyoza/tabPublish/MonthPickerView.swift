//
//  MonthPicker.swift
//  Hyoza
//
//  Created by sei on 2023/05/09.
//

import SwiftUI

enum Month: Int, CaseIterable, Identifiable, Equatable {
    case jan = 1, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
    var id: Self { self }
    var start: Date {
        self.rawValue.startOfMonth
    }
    
    var end: Date {
        self.rawValue.endOfMonth
    }
}

struct MonthPickerView: View {
    private enum K {
        static let year = "년"
        static let month = "월"
    }
    var startYear: Int
    @Binding var selectedYear: Int
    @Binding var selectedMonth: Month
    
    var body: some View {
        VStack {
            HStack {
                Text(K.year)
                Spacer()
                Picker(K.year, selection: $selectedYear) {
                    ForEach(startYear...Date().year, id:\.self) { Text("\(String($0)) \(K.year)") }
                }
                .pickerStyle(.menu)
            }
            HStack {
                Text(K.month)
                Spacer()
                Picker(K.month, selection: $selectedMonth) {
                    ForEach(Month.allCases) { Text("\($0.rawValue) \(K.month)") }
                }
                .pickerStyle(.menu)
            }
        }
        .foregroundColor(.textColor)
    }
}

struct MonthPicker_Previews: PreviewProvider {
    static var previews: some View {
        MonthPickerView(startYear: 2023, selectedYear: .constant(2023), selectedMonth: .constant(.apr))
    }
}
