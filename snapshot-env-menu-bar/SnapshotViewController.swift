//
//  SnapshotViewController.swift
//  snapshot-env-menu-bar
//
//  Created by Simon Holmes on 17/06/2018.
//  Copyright © 2018 Simon Holmes. All rights reserved.
//

import Cocoa

class SnapshotViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}

extension SnapshotViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> SnapshotViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "SnapshotViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? SnapshotViewController else {
            fatalError("Why cant i find SnapshotViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}
