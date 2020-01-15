//
//  HeroTableViewController.swift
//  Dota2Helper
//
//  Created by Jiang, Ningzhe on 1/14/20.
//  Copyright © 2020 Jiang, Ningzhe. All rights reserved.
//

import UIKit

struct Hero: Decodable {
    enum CodingKeys: String, CodingKey {
        case localized_name
    }
    let name: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .localized_name)
        print(name)
    }
}

struct HeroList: Decodable {
    var heroes: [Hero]
}

class HeroTableViewController: UITableViewController {

    var isLoadingComplete = false
    var loadingComplete: Bool {
        get {
            return isLoadingComplete
        }
        set {
            if loadingComplete == false && newValue == true {
                self.tableView.reloadData()
            }
            isLoadingComplete = newValue
        }
    }
    var heroList: [Hero] = [Hero]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData {
            self.tableView.reloadData()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    private func loadData(completion: @escaping () -> Void) {
        let url = URL(string: "https://api.opendota.com/api/heroStats")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            guard response != nil else {
                print("empty")
                return
            }

            guard let data = data else {
                print("bad data")
                return
            }
            do {
                let decoder = JSONDecoder()
                let heroList = try decoder.decode([Hero].self, from: data)
                self.heroList.append(contentsOf: heroList)
                print(heroList[0].name)
                print("decoded")
                completion()
            } catch {
                print(error)
            }
            }.resume()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.heroList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        guard indexPath.row < heroList.count else { return UITableViewCell() }
        cell.textLabel?.text = heroList[indexPath.row].name

        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
