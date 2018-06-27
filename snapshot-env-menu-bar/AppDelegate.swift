import Cocoa
import Foundation


func getPipeData(pipe: Pipe) -> String {
  let data = pipe.fileHandleForReading.readDataToEndOfFile()
  let output = String(data: data, encoding: String.Encoding.utf8)!
  if output.count > 0 {
    let lastIndex = output.index(before: output.endIndex)
    return String(output[output.startIndex..<lastIndex])
  }
  return output
}

func shell(launchPath: String, args: [String]) -> String {
  let task = Process()
  task.launchPath = launchPath
  task.arguments = args
  let pipe = Pipe()
  task.standardOutput = pipe
  task.launch()
  return getPipeData(pipe: pipe)
}


func bash(command: String, args: [String]) -> String {
  let whichPathForCommand = shell(launchPath: "/bin/bash", args: ["-l", "-c", "which \(command)"])
  return shell(launchPath: whichPathForCommand, args: args)
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
  let popover = NSPopover()


  func applicationDidFinishLaunching(_ aNotification: Notification) {
    if let button = statusItem.button {
      button.image = NSImage(named: NSImage.Name("StatusBarButtonImage"))
      button.action = #selector(togglePopover(_:))
    }
    popover.contentViewController = SnapshotViewController.freshController()
  }


  @objc func togglePopover(_ sender: Any?) {
    if popover.isShown {
      closePopover(sender: sender)
    } else {
      showPopover(sender: sender)
    }
  }

  func showPopover(sender: Any?) {
    if let button = statusItem.button {
      popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
    }
  }

  func closePopover(sender: Any?) {
    popover.performClose(sender)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

