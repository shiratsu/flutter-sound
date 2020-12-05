import UIKit
import Flutter
import FirebaseCore
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    initFirebaseSetting()
    var flutter_native_splash = 1
    UIApplication.shared.isStatusBarHidden = false

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
    func initFirebaseSetting(){
        let strBuildKey: String = Bundle.main.object(forInfoDictionaryKey: "envKey") as? String ?? ""
        let strFileName = "GoogleService-Info-"+strBuildKey
        let filePath = Bundle.main.path(forResource: strFileName, ofType: "plist")
        guard let constFilePath = filePath
            ,let fileopts = FirebaseOptions(contentsOfFile: constFilePath)
            else
        {
            //assert(false, "Couldn't load config file")
            return
            
        }
        FirebaseApp.configure(options: fileopts)
    }
}
