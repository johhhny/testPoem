//
//  PoemsTableViewController.swift
//  sttt
//
//  Created by Евгений Дорофеев on 13.07.17.
//  Copyright © 2017 Johhhny. All rights reserved.
//

import UIKit
import SQLite

class PoemsTableViewController: UITableViewController {

    var dict: [Int : String] = [:]
    var array = [""]
    var paath = ""
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPoem", for: indexPath)
        cell.textLabel?.text = array[indexPath.row]
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        index = indexPath.row
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
        if segue.identifier == "showPoem" {
            do {
                let db = try Connection("\(paath)/dataBase.db")
                let users = Table("poems")
                let text = Expression<String>("text")
                let num = Expression<Int>("num")
                let countRow = Expression<Int>("countRow")
                
                var currentStr = 0
                for (key, value) in dict {
                    if value == array[index] {
                        currentStr = key
                    }
                }
                
                var qwe = ""
                var ii = 0
                for user in try db.prepare(users) {
                    if user[num] == currentStr {
                        //print(user[text])
                        qwe = user[text]
                        ii = user[countRow]
                    }
                }
                if ii == qwe.components(separatedBy: "\n").count {
                    print("Верный стих")
                    let newVC = segue.destination as! ViewController
                    newVC.poem = qwe.components(separatedBy: "\n")
                }
                
                
            } catch {
                print("Ошибка")
            }
        }
    }
    

}
