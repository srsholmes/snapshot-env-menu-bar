import Cocoa
import Foundation


func launch(path: String, dir: String) {
  let arguments = ["-d", dir, "-p", "3000", "-o", "build", "-b", "npm run build", "-c", "develop"]
  let task = Process.launchedProcess(launchPath: path, arguments: arguments)
  task.waitUntilExit()
}

func shell(launchPath: String, arguments: [String]) -> String {
  let task = Process()
  task.launchPath = launchPath
  task.arguments = arguments

  let pipe = Pipe()
  task.standardOutput = pipe
  task.launch()

  let data = pipe.fileHandleForReading.readDataToEndOfFile()
  let output = String(data: data, encoding: String.Encoding.utf8)!
  if output.count > 0 {
    let lastIndex = output.index(before: output.endIndex)
    return String(output[output.startIndex..<lastIndex])
  }
  return output
}

func bash(command: String, arguments: [String]) -> String {
  let whichPathForCommand = shell(launchPath: "/bin/bash", arguments: ["-l", "-c", "which \(command)"])
  return shell(launchPath: whichPathForCommand, arguments: arguments)
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

  @IBAction func selectFolder(sender: AnyObject) {
    let openPanel = NSOpenPanel()
    openPanel.allowsMultipleSelection = false
    openPanel.canChooseDirectories = true
    openPanel.canCreateDirectories = false
    openPanel.canChooseFiles = false
    openPanel.begin { (result) -> Void in
      if result.rawValue == NSFileHandlingPanelOKButton {
        let chosenDirectory: String = openPanel.url!.path
        let nodePath = bash(command: "which", arguments: ["node"]);
        let snapshotBin = nodePath.replacingOccurrences(of: "bin/node", with: "bin/snapshot-env", options: .literal, range: nil)
        launch(path: snapshotBin, dir: chosenDirectory)
      }
    }
  }

  func menu() {
    let menu = NSMenu()
    menu.addItem(NSMenuItem(title: "Open Folder", action: #selector(AppDelegate.selectFolder), keyEquivalent: "o"))
    menu.addItem(NSMenuItem.separator())
    menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
    statusItem.menu = menu
  }


  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
    if let button = statusItem.button {
      button.image = NSImage(named: NSImage.Name("StatusBarButtonImage"))
      button.action = #selector(AppDelegate.selectFolder)
    }
    menu();
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

