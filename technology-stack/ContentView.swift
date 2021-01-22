//
//  ContentView.swift
//  technology-stack
//
//  Created by Niles Bingham on 1/14/21.
//

import SwiftUI

struct ContentView: View {
    private var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @State var items = [Item(id: 0, name: "Apple Watch", price: 10.00, image: "applewatch", amount: 10), Item(id: 1, name: "Iphone", price: 9.99, image: "iphone", amount: 20), Item(id: 2, name: "Macbook Air", price: 5.00, image: "laptopcomputer", amount: 10), Item(id: 3, name: "Scanner", price: 7.00, image: "scanner", amount: 10), Item(id: 4, name: "TV", price: 30.00, image: "tv", amount: 10), Item(id: 5, name: "4k TV", price: 20.00, image: "4k.tv", amount: 20)]
    @State var searchedItems = [Item(id: 0, name: "Apple Watch", price: 10.00, image: "applewatch", amount: 10), Item(id: 1, name: "Iphone", price: 9.99, image: "iphone", amount: 20), Item(id: 2, name: "Macbook Air", price: 5.00, image: "laptopcomputer", amount: 10), Item(id: 3, name: "Scanner", price: 7.00, image: "scanner", amount: 10), Item(id: 4, name: "TV", price: 30.00, image: "tv", amount: 10), Item(id: 5, name: "4k TV", price: 20.00, image: "4k.tv", amount: 20)]
    @State var cart: [Item] = []
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
                                        Image(systemName: item.image)
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

struct ItemView: View {
    @Binding var cart: [Item]
    @State private var count = 0
    var item: Item
    var body: some View {
        ZStack {
            VStack {
                NavBar(cart: $cart)
                Spacer()
                Image(systemName: item.image)
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
                        self.addToCart(item: Item(id: item.id, name: item.name, price: item.price, image: item.image, amount: count))
                    }, label: {
                        Image(systemName: "cart.fill.badge.plus")
                    })
                }
                Text(item.name).font(.title)
                Text(String(format: "$%.2f", item.price))
                if item.amount < 10 {
                    Text("Only \(item.amount) remaining.")
                }
                Text("Description")
            }
        }
        .navigationTitle(item.name)
    }
    
    func addToCart(item: Item) {
        if item.amount > 0 {
            cart.append(item)
        }
    }
}

struct CartView: View {
    @Binding var cart: [Item]
    var column: [GridItem] = Array(repeating: .init(.flexible()), count: 1)
    var body: some View {
        ScrollView {
            VStack {
                LazyVGrid (columns: column) {
                    ForEach(cart, id: \.self.id) { item in
                        HStack {
                            Image(systemName: item.image)
                            Text("\(item.amount)")
                            Text(item.name)
                            Text(String(format: "$%.2f", (Double(item.amount) * item.price)))
                            Spacer()
                            Button(action: {
                                deleteItem()
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
    
    func deleteItem() {
        print("removing item")
    }
}
