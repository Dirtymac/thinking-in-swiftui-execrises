//
//  ContentView.swift
//  PhotoList
//
//  Created by Boqin Hu on 28/6/20.
//  Copyright © 2020 Boqin Hu. All rights reserved.
//

import SwiftUI

struct PhotoListView: View {
    @ObservedObject var remote = Remote()
    
    var body: some View {
        return Group {
            if remote.photos.count == 0 {
                Text("Loading").onAppear {
                    self.remote.loadPhotos()
                }
            }
            else {
                List {
                    ForEach(remote.photos) { photo in
                        Text("author is \(photo.author)")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoListView()
    }
}
