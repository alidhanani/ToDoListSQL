//
//  ViewController.swift
//  ToDoAppForTest
//
//  Created by Nerd Mac Admin on 21/09/2018.
//  Copyright © 2018 Nerd Mac Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var AllData: [String] = []
    var AllDataDetail: [String] = []
    @IBOutlet weak var NoteTable: UITableView!

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        AllData.removeAll()
        AllDataDetail.removeAll()
        SQLManager.shared.mainFunc()
        SQLManager.shared.createTable()
        SQLManager.shared.listUser { (title, detail) in
            self.AllData.append(title)
            self.AllDataDetail.append(detail)
            self.NoteTable.reloadData()
        }
    }
    
    @IBAction func itemAdd() {
        print("Insert Tapped")
        let alert = UIAlertController(title: "Insert User", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.placeholder = "Title"
        }
        alert.addTextField { (tf) in
            tf.placeholder = "Detail"
        }
        let action = UIAlertAction(title: "Submit", style: .default, handler: { (_) in
            guard let title = alert.textFields?.first?.text,
                let detail = alert.textFields?.last?.text
                else { return }
            print(title)
            print(detail)
            if(self.AllData.contains(title)) {
                let alert = UIAlertController(title: "Error", message: "Task Exists", preferredStyle: .alert)
                let actionYes = UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.addAction(actionYes)
                self.present(alert, animated: true, completion: nil)
            } else {
                SQLManager.shared.insertUser(Title: title, Detail: detail)
                self.AllData.removeAll()
                self.AllDataDetail.removeAll()
                SQLManager.shared.listUser { (title, detail) in
                    self.AllData.append(title)
                    self.AllDataDetail.append(detail)
                    self.NoteTable.reloadData()
                }
            }
            
        })
        alert.addAction(action)
        present(alert, animated: true, completion: {
            self.NoteTable.reloadData()
        })
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ToDoTVC else {
            return UITableViewCell()
        }
        cell.ToDoItem.text = AllData[indexPath.row]
        cell.ToDoItemDetail.text = AllDataDetail[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Update Tapped")
        let alert = UIAlertController(title: "Update User", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.placeholder = "Title"
            tf.text = self.AllData[indexPath.row]
        }
        alert.addTextField { (tf) in
            tf.placeholder = "Detail"
            tf.text = self.AllDataDetail[indexPath.row]
        }
        let action = UIAlertAction(title: "Update", style: .default, handler: { (_) in
            let title = alert.textFields?.first?.text
            let detail = alert.textFields?.last?.text
            SQLManager.shared.updateUser(Name: title!, Detail: detail!)
            self.AllData.removeAll()
            SQLManager.shared.listUser { (title, detail) in
                self.AllData.append(title)
                self.NoteTable.reloadData()
            }
            
        })
        alert.addAction(action)
        let actionNO = UIAlertAction(title: "No", style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(actionNO)
        present(alert, animated: true, completion: {
            self.NoteTable.reloadData()
        })
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Delte Tapped")
            let alert = UIAlertController(title: "Delete", message: "Do You Want To Delete?", preferredStyle: .alert)
            let actionYes = UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                SQLManager.shared.deleteUser(Title: self.AllData[indexPath.row])
                self.AllData.removeAll()
                self.AllDataDetail.removeAll()
                SQLManager.shared.listUser { (title, detail) in
                    self.AllData.append(title)
                    self.AllDataDetail.append(detail)
                    self.NoteTable.reloadData()
                }
                
            })
            alert.addAction(actionYes)
            let actionNO = UIAlertAction(title: "No", style: .default, handler: { (_) in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(actionNO)
            present(alert, animated: true, completion: {
                self.NoteTable.reloadData()
            })
        }
    }
    
}

