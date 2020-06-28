//
//  Remote.swift
//  PhotoList
//
//  Created by Boqin Hu on 28/6/20.
//  Copyright © 2020 Boqin Hu. All rights reserved.
//

import Foundation

final class Remote: ObservableObject {
    private let remoteURL: String = "https://picsum.photos/v2/list"
    private let urlSession: URLSession = URLSession(configuration: .default)
    @Published var photos: [Photo] = [Photo]()
    
    func loadPhotos() {
        guard let url = URL(string: remoteURL) else { return }
        urlSession.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error is \(error.localizedDescription)")
            }
            else if let data = data {
                DispatchQueue.main.async {
                    do {
                        self.photos = try JSONDecoder().decode([Photo].self, from: data)
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }.resume()
    }
}
