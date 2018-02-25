//
//  recordingListVC.swift
//  sleepRecorder
//
//  Created by donezio on 2/23/18.
//  Copyright © 2018 macbook pro. All rights reserved.
//

import UIKit

class recordingListVC: UITableViewController {

    let cellId = "cellId"
    var fileNameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        readList()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if fileNameArray.count == 0 {
            return 0
        }
        else{
            return (fileNameArray.count)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = fileNameArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if editingStyle == .delete {
            self.fileNameArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            //TODO : delet file
        }
    }
    
    func readList(){
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let enumerator = FileManager.default.enumerator(at : docsDirect, includingPropertiesForKeys: nil,options: [.skipsHiddenFiles, .skipsPackageDescendants])!.allObjects
        for tmp in enumerator{
            let tmp = tmp as! URL
            let nameString = parseFileName(tmp)
            fileNameArray.append(nameString)
        }
        self.tableView.reloadData()
    }
    
    func parseFileName(_ path : URL) -> String{
        let withoutExt = path.deletingPathExtension()
        let name = withoutExt.lastPathComponent
        let result = name.substring(from: name.index(name.startIndex, offsetBy: 0))
        return result
    }
}
