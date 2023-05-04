//
//  ContentView.swift
//  Oroji
//
//  Created by 최명근 on 2023/05/02.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
        Text("Hello, world")
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
