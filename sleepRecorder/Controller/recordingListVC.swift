//
//  recordingListVC.swift
//  sleepRecorder
//
//  Created by donezio on 2/23/18.
//  Copyright © 2018 macbook pro. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import CoreAudio

class recordingListVC: UITableViewController,AVAudioPlayerDelegate {

    let cellId = "cellId"
    var fileNameArray = [audioFile]()
    var audioSession = AVAudioSession.sharedInstance()
    var player : AVAudioPlayer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        readList()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
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
        cell.textLabel?.text = fileNameArray[indexPath.row].fileName
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tmpURL = fileNameArray[indexPath.row].urlPath
        guard self.player != nil else {
            playBack(tmpURL!)
            return
        }
        playStop()
    }
    
    func readList(){
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let enumerator = FileManager.default.enumerator(at : docsDirect, includingPropertiesForKeys: nil,options: [.skipsHiddenFiles, .skipsPackageDescendants])!.allObjects
        for tmp in enumerator{
            let tmp = tmp as! URL
            let tmp2 = tmp as NSURL
            let nameString = parseFileName(tmp)
            let tmpFile = audioFile()
            tmpFile.fileName = nameString
            tmpFile.urlPath = tmp2
            fileNameArray.append(tmpFile)
        }
        self.tableView.reloadData()
    }
    
    func parseFileName(_ path : URL) -> String{
        let withoutExt = path.deletingPathExtension()
        let name = withoutExt.lastPathComponent
        let result = name.substring(from: name.index(name.startIndex, offsetBy: 0))
        return result
    }
    
    
    func playBack(_ url : NSURL){
        let audioSession = AVAudioSession.sharedInstance()
        do{
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        }
        catch{
            print("errir \(error)")
            return
        }
        //
        
        let fileURL = url
        /*
        do {
            let resources = try fileURL.resourceValues(forKeys:[.fileSizeKey])
            let fileSize = resources.fileSize!
            print ("\(fileSize)")
        } catch {
            print("Error: \(error)")
        }
         */
        do{
            self.player = try AVAudioPlayer(contentsOf: fileURL as URL)
            //player?.delegate = self
            player?.prepareToPlay()
            DispatchQueue.global().async {
                self.player?.play()
                print("Sound should be playing")
            }
        }
        catch{
            print("error play back")
            return
        }
        do{
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setActive(true)
        }
        catch{
            print("errir \(error)")
            return
        }
    }
    
    func playStop(){
        guard let tmpPlayer = self.player else {return}
        if tmpPlayer.isPlaying == true{
            tmpPlayer.stop()
            self.player = nil
        }
    }
}
