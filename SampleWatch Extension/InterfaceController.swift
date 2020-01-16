//
//  InterfaceController.swift
//  SampleWatch Extension
//
//  Created by sreekanth reddy iragam reddy on 1/15/20.
//  Copyright © 2020 SampleWatch. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var tableController: WKInterfaceTable!
    var dataSaved: String!
    var listData: [String]!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
            fetchWatchData()
        }
    }

    func updateUI() {
        if dataSaved == nil {
            return
        }
        let values = dataSaved.split(separator: " ")
        listData = values.map{String($0)}
        tableController.setNumberOfRows(values.count, withRowType: "AllValues")
        values.enumerated().forEach { (index, str) in
            let row = tableController.rowController(at: index) as? AllDetailsScreenRow
            row?.allValuesLabel.setText(String(str))
            row?.valueLabel.setText(String(index))
        }
    }

}

extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            fetchWatchData()
        }
    }

    // didReceiveApplicationContext is fast and immediately recives the response
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if applicationContext.keys.count > 0 {
            guard let watchData1 = applicationContext["WatchData"] as? String else { return }
                   saveToFile(watchData: watchData1)
                   dataSaved = watchData1
        }
    }


    // Did Receive Message is like a queue and takes time to get the data to be shown on Watch App
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
//        guard let watchData1 = message["WatchData"] as? String else { return }
//        saveToFile(watchData: watchData1)
//        dataSaved = watchData1
//    }

    func fetchWatchData() {
       let dataRead = readFile()
       dataSaved = dataRead
       updateUI()
    }

    func saveToFile(watchData: String) {
        do {
            let jsonData = try JSONEncoder().encode(watchData)
            try? jsonData.write(to: documentDirectory(), options: .atomic)
        } catch let error { print(error) }

    }

    func readFile() -> String? {
        let decodedData = try? String(contentsOf: documentDirectory(), encoding: String.Encoding.utf8)
        if decodedData != nil {
            return decodedData
        }
        return nil
    }

    func documentDirectory() -> URL {
        let file = "watchfile.txt"
        let directoryName = "Watch"
        let filemanager = FileManager.default
        let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = directoryPath[0]
        let dataPath = documentsDirectory.appending(directoryName)

        if !filemanager.fileExists(atPath: dataPath) {
            try? filemanager.createDirectory(atPath: dataPath, withIntermediateDirectories: false, attributes: nil)
        } else {
            print("file not created")
        }

        let filePath = dataPath.appending(file)
        let url = URL(fileURLWithPath: filePath)

        return url
    }
}

extension InterfaceController {
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        if rowIndex == 0 {
            let selectedData = listData[rowIndex]
            let finalData = [selectedData, String(rowIndex)]
            self.pushController(withName: "Screen1", context: finalData)
        } else {
            let selectedData = listData[rowIndex]
            let finalData = [selectedData, String(rowIndex)]
            self.pushController(withName: "Screen1", context: finalData)
        }
    }
}
