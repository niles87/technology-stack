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
    @State private var openSearch = false
    @Binding var cart: [Item]
    @Binding var itemList: [Item]
    @Binding var searchedItems: [Item]
    var body: some View {
        HStack {
            Text("Tech Stack")
                .font(.title)
            Spacer()
            if openSearch {
                TextField(
                    "search",
                    text: $search
                ) { isEditing in
                    self.isEditing = isEditing
                    
                }.autocapitalization(.none)
                .disableAutocorrection(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 150)
                .border(Color(UIColor.separator))
                Button(action: {
                    searchItems()
                }, label: {
                    Image(systemName: "magnifyingglass")
                })
            } else {
                Button(action: {
                    openSearch.toggle()
                }, label: {
                    Image(systemName: "magnifyingglass")
                })
            }
            NavigationLink(
                destination: CartView(cart: $cart),
                label: {
                    Image(systemName: "cart.circle")
                })
        }
        .padding(5)
        .frame(width: UIScreen.main.bounds.width, height: 50)
        .background(Color(.quaternaryLabel))
    }
    
    func searchItems() {
        self.searchedItems = search.isEmpty ? itemList : itemList.filter {$0.name.contains(search)}
        self.search = ""
        self.openSearch = false 
    }
}

struct NavBar: View {
    @Binding var cart: [Item]
    var body: some View {
        HStack{
            Text("Tech Stack")
                .font(.title)
            Spacer()
            NavigationLink(
                destination: CartView(cart: $cart),
                label: {
                    Image(systemName: "cart.circle")
                })
        }
        .padding(5)
        .frame(width: UIScreen.main.bounds.width, height: 50)
        .background(Color(.quaternaryLabel))
    }
}
