//
//  ContentView.swift
//  technology-stack
//
//  Created by Niles Bingham on 1/14/21.
//

import SwiftUI

struct ContentView: View {
    private var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var items = ["First Item", "Second Item", "Third Item", "Fourth Item", "Fifth Item", "Sixth Item"]
    var body: some View {
        NavigationView {
            VStack {
                TitleBar()
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(items, id: \.self) {item in
                            Text(item)
                                .frame(width: 150, height: 150)
                                .background(Color(.separator))
                                .padding()
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
