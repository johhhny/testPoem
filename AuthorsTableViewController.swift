//
//  AuthorsTableViewController.swift
//  sttt
//
//  Created by user on 13.07.17.
//  Copyright © 2017 Johhhny. All rights reserved.
//

import UIKit
import SQLite

class AuthorsTableViewController: UITableViewController {

    //var str = [""]
    var dict: [Int : String] = [:]
    var path = ""
    var id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        //print(path)
        do {
            let db = try Connection("\(path)/dataBase.db")
            let users = Table("authors")
            let name = Expression<String>("name")
            let number = Expression<Int>("number")

            for user in try db.prepare(users) {
                //print("name: \(user[name])")
                dict[user[number]] = user[name]
                //str.append(user[name])
            }
            print(dict)
            //str.removeFirst()
            tableView.reloadData()
        } catch {
            print("Ошибка")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dict.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellAuthor", for: indexPath)
        //cell.textLabel?.text = str[indexPath.row]
        //print(str[indexPath.row])
        // Configure the cell...
        cell.textLabel?.text = dict[indexPath.row + 1]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //id = 0
        //id = indexPath.row + 1
        //print(id)
    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        id = 0
        id = indexPath.row + 1
        return indexPath
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPoems" {
            var dictPoems: [Int : String] = [:]
            var tempArray: [String] = []
            do {
                let db = try Connection("\(path)/dataBase.db")
                let users = Table("namePoems")
                let name = Expression<String>("name")
                let number = Expression<Int>("number")
                let author = Expression<Int>("author")
                
                let query = users.select(name, number, author)  // SELECT "email" FROM "users"
                    .filter(author == id)     // WHERE "name" IS NOT NULL
                    //.order(email.desc, name) // ORDER BY "email" DESC, "name"
                    //.limit(5, offset: 1)
                
                
                for rt in try db.prepare(query) {
                    print(rt)
                }
                
                for user in try db.prepare(users) {
                    if user[author] == id {
                        dictPoems[user[number]] = user[name]
                    }
                }
                
                for value in dictPoems.values {
                    tempArray.append(value)
                }
                
                let newVC = segue.destination as! PoemsTableViewController
                newVC.dict = dictPoems
                newVC.array = tempArray
                newVC.paath = path
            } catch {
                print("Ошибка")
            }
        }
    }
    

}
