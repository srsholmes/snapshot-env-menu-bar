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
  @IBOutlet weak var outputFolderTextField: NSTextView!
  @IBOutlet weak var commitTextField: NSTextField!
  @IBOutlet weak var buildTextField: NSTextField!
  @IBOutlet weak var appOutput: NSTextField!
}

extension SnapshotViewController {
  private func launch(launchPath: String, args: [String]) {
    let pipe = Pipe()
    let outHandle = pipe.fileHandleForReading
    outHandle.readabilityHandler = { pipe in
      if let line = String(data: pipe.availableData, encoding: String.Encoding.utf8) {
        // Update your view with the new text here
        print("New output: \(line)")
        print(self.appOutput)
        self.appOutput.stringValue = line;
      } else {
        print("Error decoding data: \(pipe.availableData)")
      }
    }
    let task = Process()
    task.launchPath = launchPath
    task.arguments = args
    task.standardOutput = pipe
    task.launch()
    task.waitUntilExit()
  }

  @IBAction func selectFolder(sender: AnyObject) {
    let openPanel = NSOpenPanel()
    openPanel.allowsMultipleSelection = false
    openPanel.canChooseDirectories = true
    openPanel.canCreateDirectories = false
    openPanel.canChooseFiles = false
    openPanel.begin { (result) -> Void in
      if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
        let chosenDirectory: String = openPanel.url!.path
        let nodePath = bash(command: "which", args: ["node"]);
        let snapshotBin = nodePath.replacingOccurrences(of: "bin/node", with: "bin/snapshot-env", options: .literal, range: nil)
//        let args = [
//          "-d",
//          chosenDirectory,
//          "-p",
//          self.portTextField.stringValue,
//          "-o",
//          self.outputFolderTextField.stringValue,
//          "-b",
//          self.buildTextField.stringValue,
//          "-c",
//          self.commitTextField.stringValue
//        ]
        let args = [
          "-d",
          chosenDirectory,
          "-p",
          "3000",
          "-o",
          "build",
          "-b",
          "npm run build",
          "-c",
          "develop"
        ]
        self.launch(launchPath: snapshotBin, args: args)
      }
    }
  }
}

extension SnapshotViewController {
  static func freshController() -> SnapshotViewController {
    let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
    let identifier = NSStoryboard.SceneIdentifier(rawValue: "SnapshotViewController")
    guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? SnapshotViewController else {
      fatalError("Why cant i find SnapshotViewController? - Check Main.storyboard")
    }
    return viewcontroller
  }
}
