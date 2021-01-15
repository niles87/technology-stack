//
//  Stock.swift
//  technology-stack
//
//  Created by Niles Bingham on 1/14/21.
//

import Foundation
import SQLite3

struct Item {
    var id: Int
    var name: String
    var price: Double
    var image: String
    var amount: Int
}

class ShoppingCartManager {
    var database: OpaquePointer!
    
    //singleton
    static let main = ShoppingCartManager()
    
    private init() {
        
    }
    
    func connect() {
        if database != nil {
            return
        }
        do {
            let databaseURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("notes.sqlite3")
            
            if sqlite3_open(databaseURL.path, &database) != SQLITE_OK {
                print("could not connect")
            }
            
            if sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS shopping_cart (name TEXT, price REAL, img TEXT, amount INTEGER)", nil, nil, nil) != SQLITE_OK {
                print("Could not create table")
            }
                
        }
        catch let error {
            print("Couldn't connect to database", error)
        }
    }
    
    func getCart() -> [Item] {
        connect()
        var result: [Item] = []
        
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "SELECT rowid, name, price, image, amount FROM shopping_cart", -1, &statement, nil) != SQLITE_OK {
            print("Error getting data")
            return []
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            result.append(Item(id: Int(sqlite3_column_int(statement, 0)), name: String(cString: sqlite3_column_text(statement, 1)), price: Double(sqlite3_column_double(statement, 2)), image: String(cString: sqlite3_column_text(statement, 3)), amount: Int(sqlite3_column_int(statement, 4))))
        }
        
        sqlite3_finalize(statement)
        
        return result
    }
    
    func save(item: Item) {
        connect()
        var statement: OpaquePointer!
        
        if sqlite3_prepare(database, "INSERT INTO shopping_cart (name, price, image, amount) VALUES (?,?,?,?)", -1, &statement, nil) != SQLITE_OK {
            print("could not update note")
        }
        
        sqlite3_bind_text(statement, 1, NSString(string: item.name).utf8String, -1, nil)
        
        sqlite3_bind_double(statement, 2, item.price)
        
        sqlite3_bind_text(statement, 3, NSString(string: item.image).utf8String, -1, nil)
        
        sqlite3_bind_int(statement, 4, Int32(item.amount))
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error running insert")
        }
        
        sqlite3_finalize(statement)
    }
    
    func updateAmount(item: Item) -> Bool {
        connect()
        var statement: OpaquePointer!
        
        if sqlite3_prepare(database, "UPDATE shopping_cart SET amount = ? WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("could not update note")
            return false
        }
        
        sqlite3_bind_int(statement, 1, Int32(item.amount))
        
        sqlite3_bind_int(statement, 2, Int32(item.id))
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error running update")
            return false
        }
        
        sqlite3_finalize(statement)
        return true
    }
    
    func delete(item: Item) -> Bool {
        connect()
        
        var statement: OpaquePointer!
        
        if sqlite3_prepare(database, "DELETE FROM shopping_cart WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("could not delete item")
            return false
        }
        
        sqlite3_bind_int(statement, 1, Int32(item.id))
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error running delete")
            return false
        }
        
        sqlite3_finalize(statement)
        
        return true
    }
}
