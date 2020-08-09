//
//  CollapsibleView.swift
//  Layout-Exercises
//
//  Created by Boqin Hu on 9/8/20.
//  Copyright © 2020 Boqin Hu. All rights reserved.
//

import SwiftUI

struct Collapsible<Element, Content: View>: View {
    var data: [Element]
    var expanded: Bool = false
    var content:(Element) -> Content
    var body: some View {
        HStack {
            ForEach(data.indices, content: {
                self.child(at: $0)
            })
        }
        .border(Color.black, width: 4)
    }

    func child(at index: Int) -> some View {
        let showExpended = expanded || index == self.data.endIndex - 1
        return content(data[index])
            .frame(width: showExpended ? nil : 10, alignment: Alignment(horizontal: .leading, vertical: .center))
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello")
            .padding(10)
            .background(Color.gray)
            .badge(count: 5)
    }
}
