//
//  ContentView.swift
//  technology-stack
//
//  Created by Niles Bingham on 1/14/21.
//

import SwiftUI

struct ContentView: View {
    private var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @State var items = API.main.getItems()
    @State var searchedItems = API.main.getItems()
    @State var cart: [CartItem] = []
    var body: some View {
        NavigationView {
            VStack {
                TitleBar(cart: $cart, itemList: $items, searchedItems: $searchedItems)
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(searchedItems, id: \.self.id) {item in
                            NavigationLink(
                                destination: ItemView(cart: $cart, item: item),
                                label: {
                                    VStack{
                                        Image(systemName: item.name)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 75, height: 75)
                                        
                                        Text(item.name)
                                    }
                                    .frame(width: 150, height: 150)
                                    .background(Color(.separator))
                                    .padding()
                                })
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

struct CartItem {
    var id: Int
    var name: String
    var price: Double
    var amount: Int
}

struct ItemView: View {
    @Binding var cart: [CartItem]
    @State private var count = 0
    @State private var showAlert = false
    var item: Item
    var body: some View {
        ZStack {
            VStack {
                NavBar(cart: $cart)
                Image(systemName: item.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                    .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 50.0, trailing: 0.0))
                HStack {
                    TextField("amount", value: $count, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .frame(width: 50)
                        .border(Color(.separator))
                    Button(action: {
                        if !self.addToCart(item: CartItem(id: item.id, name: item.name, price: item.price, amount: count)) {
                            showAlert = true
                        }
                    }, label: {
                        Image(systemName: "cart.fill.badge.plus")
                    }).alert(isPresented: $showAlert, content: {
                        Alert(title: Text("Need an amount greater than zero"))
                    })
                }
                Text(item.name).font(.title)
                Text(String(format: "$%.2f", item.price))
                if item.available_stock < 10 {
                    Text("Only \(item.available_stock) remaining.")
                }
                Text(item.description)
                Spacer()
            }
        }
        .navigationTitle(item.name)
    }
    
    private func addToCart(item: CartItem) -> Bool {
        if item.amount > 0 {
            for i in cart {
                if i.id == item.id {
                    updateItemInCart(id: i.id, amount: item.amount)
                    return true
                }
            }
            self.cart.append(item)
            return true
        }
        return false
    }
    
    private func updateItemInCart(id: Int, amount: Int) {
        for (idx, item) in cart.enumerated() {
            if id == item.id {
                self.cart[idx].amount += amount
                return
            }
        }
    }
}

struct CartView: View {
    @Binding var cart: [CartItem]
    var column: [GridItem] = Array(repeating: .init(.flexible()), count: 1)
    var body: some View {
        ScrollView {
            VStack {
                LazyVGrid (columns: column) {
                    ForEach(cart, id: \.self.id) { item in
                        HStack {
                            Image(systemName: item.name)
                            Text("\(item.amount)")
                            Text(item.name)
                            Text(String(format: "$%.2f", (Double(item.amount) * item.price)))
                            Spacer()
                            Button(action: {
                                deleteItem(id: item.id)
                            }, label: {
                                Text("X").font(.system(size: 15, weight: .heavy))
                            })
                            .frame(width: 20, height: 20)
                            .background(Color(.red))
                            .foregroundColor(.white)
                            .cornerRadius(10.0)
                        }.padding()
                    }
                }
                Spacer()
                Text(String(format: "Total: $%.2f", getTotal()))
                NavigationLink(
                    destination: CheckoutView(total: getTotal()),
                    label: {
                        Text("Checkout")
                    })
            }
        }.navigationTitle("Cart")
    }
    
    func getTotal() -> Double {
        var total = 0.0
        for item in cart {
            total += (Double(item.amount) * item.price)
        }
        return total
    }
    
    func deleteItem(id: Int) {
        
        for (idx, item) in cart.enumerated() {
            if item.id == id {
                self.cart.remove(at: idx)
            }
        }
    }
}

