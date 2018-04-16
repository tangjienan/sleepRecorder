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
import SnapKit

class recordingListVC: UITableViewController,AVAudioPlayerDelegate {

    let cellId = "cellId"
    var fileNameArray = [audioFile]()
    var audioSession = AVAudioSession.sharedInstance()
    var player : AVAudioPlayer?
    let fileManager = FileManager.default
    var clearButton : UIButton?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        readList()
    }
    override func viewWillAppear(_ animated: Bool) {
        readList()
        //self.tableView.reloadData()
        //self.tableView.layoutIfNeeded()
    }
    
    // MARK:- Table view data source
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
            
            let tmp = self.fileNameArray[indexPath.row]
            do {
                print(tmp.urlPath)
                try fileManager.removeItem(at: tmp.urlPath as! URL)
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = headerView()
        self.clearButton = vw.clearButton
        self.clearButton?.addTarget(self, action: #selector(clearAllFiles), for: .touchDown)
        return vw
    }
    
    @objc func clearAllFiles(){
        fileNameArray.removeAll()
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let enumerator = FileManager.default.enumerator(at : docsDirect, includingPropertiesForKeys: nil,options: [.skipsHiddenFiles, .skipsPackageDescendants])!.allObjects
        for tmp in enumerator{
            let tmp = tmp as! URL
            do{
                try fileManager.removeItem(at: tmp)
            }
            catch{
                print("errir \(error)")
                return
            }
        }
        self.tableView.reloadData()
    }
    
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func readList(){
        fileNameArray.removeAll()
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let enumerator = FileManager.default.enumerator(at : docsDirect, includingPropertiesForKeys: nil,options: [.skipsHiddenFiles, .skipsPackageDescendants])!.allObjects
        for tmp in enumerator{
            let tmp = tmp as! URL
            let tmp2 = tmp as NSURL
            let nameString = parseFileName(tmp)
            let tmpDouble = Double(nameString)
            let nameStringFormat = convertTimeStampToDate(tmpDouble!)
            let tmpFile = audioFile()
            tmpFile.fileName = nameStringFormat
            tmpFile.urlPath = tmp2
            fileNameArray.append(tmpFile)
        }
        self.tableView.reloadData()
    }
    
    func convertTimeStampToDate(_ timeStamp : Double) -> String{
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "PST") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
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
        // getting the size of the file
        
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
        else{
            self.player = nil
        }
    }
}
