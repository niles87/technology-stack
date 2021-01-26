//
//  ApiHelper.swift
//  technology-stack
//
//  Created by Niles Bingham on 1/23/21.
//

import Foundation

struct Item: Codable {
    var id: Int
    var name: String
    var price: Double
    var available_stock: Int
    var description: String 
}

struct ItemList: Codable {
    var results: [Item]
}

class API {
    
    static var main = API()
    
    private init () {}
    
    func getItems() -> [Item] {
        let semaphore = DispatchSemaphore(value: 0)
        guard let req = URL(string: "http://127.0.0.1:5000/stock") else {
            return []
        }
        var items: [Item]!
        URLSession.shared.dataTask(with: req) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let itemList = try JSONDecoder().decode(ItemList.self, from: data)
                items = itemList.results
            }
            catch let error {
                print("error: \(error)")
            }
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(wallTimeout: .distantFuture)
        return items
    }

    func updateStock(item: CartItem) -> Bool {
        var updated = false
        let semaphore = DispatchSemaphore(value: 0)
        let url = URL(string: "http://127.0.0.1:5000/stock")
        var request = URLRequest(url: url!)
        let parameters: [String:Any] = [
            "id": item.id,
            "amount": item.amount
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("couldnt serialize jsonData")
            return updated
        }
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                print(error)
                return
            }
            if let response = response {
                let res = response as! HTTPURLResponse
                
                if res.statusCode == 200 {
                    updated = true
                }
            }
            semaphore.signal()
        }.resume()
        semaphore.wait()
        
        return updated
    }
}
