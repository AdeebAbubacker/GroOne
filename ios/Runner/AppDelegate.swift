import Flutter
import UIKit
import GoogleMaps
import BackgroundTasks  

@main
@objc class AppDelegate: FlutterAppDelegate {
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Google Maps
    GMSServices.provideAPIKey("AIzaSyDE6bJadM90V5IjxMWG99cydVMTDj56PXY")
    
    // Register Flutter plugins
    GeneratedPluginRegistrant.register(with: self)
    
    // Register your background processing task
    BGTaskScheduler.shared.register(
      forTaskWithIdentifier: "com.gro.oneapp.refresh",  
      using: nil
    ) { task in
      self.handleAppRefresh(task: task as! BGProcessingTask)
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func handleAppRefresh(task: BGProcessingTask) {
    print("Background task executed")
    task.setTaskCompleted(success: true)
  }
}
