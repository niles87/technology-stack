//
//  ApiHelper.swift
//  technology-stack
//
//  Created by Niles Bingham on 1/23/21.
//

import Foundation

struct Itm: Codable {
    var id: Int
    var name: String
    var price: Double
    var available_stock: Int
    var description: String 
}

struct ItemList: Codable {
    var results: [Itm]
}

class API {
    
    func getItems() -> [Itm] {
        var items: [Itm] = []
        let semaphore = DispatchSemaphore(value: 0)
        let url = URL(string: "")
        guard let req = url else {
            return []
        }
        URLSession.shared.dataTask(with: req) { (data, response, error) in
            semaphore.signal()
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
            
        }.resume()
        
        semaphore.wait()
        return items
    }
    
    func updateStock(item: Item) -> Bool {
        var updated = false
        let semaphore = DispatchSemaphore(value: 0)
        let url = URL(string: "")
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
            semaphore.signal()
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
        }.resume()
        semaphore.wait()
        
        return updated
    }
}
