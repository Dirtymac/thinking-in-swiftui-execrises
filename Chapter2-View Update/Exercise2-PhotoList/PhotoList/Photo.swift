//
//  Photo.swift
//  PhotoList
//
//  Created by Boqin Hu on 28/6/20.
//  Copyright © 2020 Boqin Hu. All rights reserved.
//

import Foundation

struct Photo: Codable, Identifiable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let download_url: String
}
