//
//  PeriodSegmentView.swift
//  Hyoza
//
//  Created by sei on 2023/05/08.
//

import SwiftUI

enum PeriodSelection: String, CaseIterable {
    case custom = "날짜 지정"
    case oneMonth = "한 달"
    case whole = "전체"
}


struct PeriodSegmentView: View {
    @Binding var segmentationSelection: PeriodSelection
    
    private enum K {
        static let pickerTitle = "기간을 고르세요"
    }
    
    init(selection: Binding<PeriodSelection>) {
        self._segmentationSelection = selection
        UISegmentedControl.appearance().backgroundColor = .cardSecondaryColor
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
    }
    
    var body: some View {
        Picker(K.pickerTitle, selection: $segmentationSelection) {
            ForEach(PeriodSelection.allCases, id: \.self) {
                Text($0.rawValue)
            }
        }
        .pickerStyle(.segmented)
        .padding()
    }
}


struct PeriodSegmentView_Previews: PreviewProvider {
    static var previews: some View {
        PeriodSegmentView(selection: .constant(.custom))
    }
}
