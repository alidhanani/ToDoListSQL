//
//  SQLManager.swift
//  ToDoAppForTest
//
//  Created by Nerd Mac Admin on 21/09/2018.
//  Copyright © 2018 Nerd Mac Admin. All rights reserved.
//

import Foundation
import SQLite

class SQLManager {
    static let shared = SQLManager()
    init() {
        
    }
    
    var database: Connection!
    
    let usersTable = Table("users")
    let id = Expression<Int>("id")
    let title = Expression<String>("title")
    let task = Expression<String>("tast")
    
    func mainFunc() {
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            let databaseFileName = "users.sqlite3"
            let databaseFilePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(databaseFileName)"
            let database = try Connection(databaseFilePath)
            self.database = database
        } catch {
            print(error)
        }
    }
    
    func createTable() {
        print("Create Table")
        
        let createTable = self.usersTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.title)
            table.column(self.task, unique: true)
        }
        
        do {
            try self.database.run(createTable)
            print("Created Table")
        } catch {
            print(error)
        }
    }
    
    func insertUser(Title title: String, Detail detail: String) {
        print("Insert Tapped")
        let insertUser = self.usersTable.insert(self.title <- title, self.task <- detail)
        do {
            try self.database.run(insertUser)
            print("Inserted User")
        } catch {
            print(error)
        }
    }
    
    func listUser(completion: @escaping (String, String)->()) {
        print( "List User")
        
        do {
            let users = try self.database.prepare(self.usersTable)
            for user in users {
                completion(user[self.title], user[self.task])
            }
        } catch {
            print(error)
        }
    }
    
    func updateUser(Name name: String, Detail detail: String) {
        print("Update Tapped")
        let user = self.usersTable.filter(self.title == name)
        let updateUser = user.update(self.title <- name, self.task <- detail)
        do {
            try self.database.run(updateUser)
            print("Updated User")
        } catch {
            print(error)
        }
    }
    
    func deleteUser(Title title: String) {
        print("Delete Tapped")
        let user = self.usersTable.filter(self.title == title)
        let updateUser = user.delete()
        do {
            try self.database.run(updateUser)
            print("Deleted User")
        } catch {
            print(error)
        }
    }
    
}
