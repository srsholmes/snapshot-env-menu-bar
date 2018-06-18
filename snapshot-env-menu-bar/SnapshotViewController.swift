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

  @IBOutlet weak var portTextField: NSTextField!
  @IBOutlet weak var outputFolderTextField: NSTextField!
  @IBOutlet weak var commitTextField: NSTextField!
  @IBOutlet weak var buildTextField: NSTextField!
}

extension SnapshotViewController {
  @IBAction func selectFolder(sender: AnyObject) {
    let openPanel = NSOpenPanel()
    print(self.portTextField.stringValue)
    print(self.outputFolderTextField.stringValue)
    print(self.commitTextField.stringValue)
    print(self.buildTextField.stringValue)
    openPanel.allowsMultipleSelection = false
    openPanel.canChooseDirectories = true
    openPanel.canCreateDirectories = false
    openPanel.canChooseFiles = false
    openPanel.begin { (result) -> Void in
      if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
        let chosenDirectory: String = openPanel.url!.path
        let nodePath = bash(command: "which", arguments: ["node"]);
        let snapshotBin = nodePath.replacingOccurrences(of: "bin/node", with: "bin/snapshot-env", options: .literal, range: nil)

        let arguments = [
          "-d",
          chosenDirectory,
          "-p",
          self.portTextField.stringValue,
          "-o",
          self.outputFolderTextField.stringValue,
          "-b",
          self.buildTextField.stringValue,
          "-c",
          self.commitTextField.stringValue
        ]
        launch(path: snapshotBin, args: arguments)
      }
    }
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
