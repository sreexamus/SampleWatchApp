//
//  Screen1InterfaceController.swift
//  SampleWatchApp
//
//  Created by sreekanth reddy iragam reddy on 1/16/20.
//  Copyright © 2020 SampleWatch. All rights reserved.
//

import WatchKit
import Foundation


class Screen1InterfaceController: WKInterfaceController {

    @IBOutlet weak var label2: WKInterfaceLabel!
    @IBOutlet weak var label1: WKInterfaceLabel!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        let valueIs = context as? [String]
        label1.setText(valueIs?.first)
        label2.setText(valueIs?.last)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
