//
//  TitleBar.swift
//  technology-stack
//
//  Created by Niles Bingham on 1/15/21.
//

import SwiftUI

struct TitleBar: View {
    @State var search: String = ""
    @State private var isEditing = false
    var body: some View {
        HStack {
            Text("Tech Stack")
                .font(.title)
            TextField(
                "search",
                text: $search
            ) { isEditing in
                self.isEditing = isEditing
                
            }.autocapitalization(.none)
            .disableAutocorrection(true)
            .border(Color(UIColor.separator))
            Button(action: {
                print("clicking search")
            }, label: {
                Image(systemName: "magnifyingglass")
            })
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width, height: 50)
        .background(Color(.quaternaryLabel))
    }
}
