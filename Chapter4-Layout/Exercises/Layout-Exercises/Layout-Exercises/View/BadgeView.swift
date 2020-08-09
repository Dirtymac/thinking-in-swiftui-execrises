//
//  BadgeView.swift
//  Layout-Exercises
//
//  Created by Boqin Hu on 9/8/20.
//  Copyright © 2020 Boqin Hu. All rights reserved.
//

import SwiftUI

extension View {
    func badge(count: Int?, frame: CGSize) -> some View {
        overlay(
            ZStack {
                if count != 0 {
                    Circle()
                        .fill(Color.red)
                    Text("\(count ?? 0)")
                        .foregroundColor(.white)
                        .font(.caption)
                }
            }
            .offset(x: frame.width/2, y: -frame.height/2)
            .frame(width: frame.width, height: frame.height)
            , alignment: .topTrailing)
    }
}
