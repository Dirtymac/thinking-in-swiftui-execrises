//
//  ContentView.swift
//  Layout-Exercises
//
//  Created by Boqin Hu on 9/8/20.
//  Copyright © 2020 Boqin Hu. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let colors: [(Color, CGFloat)] = [(Color(white: 0.3), 50), (Color(white: 0.8), 30), (Color(white: 0.5), 75)]
    
    @State var expanded: Bool = true
    
    var body: some View {
        VStack {
            Collapsible(data: colors, expanded: expanded) { (item: (Color, CGFloat)) in
                Rectangle()
                    .fill(item.0)
                    .frame(width: item.1, height: item.1)
            }
            Button(action: { withAnimation(.default) {
                self.expanded.toggle() } }, label: {
                    Text(self.expanded ? "Collapse" : "Expand")
            })
            
            Text("Hello")
                .padding(10)
                .background(Color.gray)
                .badge(count: 5, frame: CGSize(width: 24, height: 24))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
