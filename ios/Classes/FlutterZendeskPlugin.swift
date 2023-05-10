import Flutter
import UIKit
import ZendeskCoreSDK
import SupportSDK
import CommonUISDK

public class FlutterZendeskPluginClass: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_zendesk", binaryMessenger: registrar.messenger())
    let instance = FlutterZendeskPluginClass()
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.addApplicationDelegate(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

       let method = call.method
              let dic = call.arguments as? Dictionary<String, Any>
              
       switch(method){
            case "initialize":
                self.initSupport(dictionary: dic!)

                break;
            case "showRequestList":
            //  CommonTheme.currentTheme.primaryColor = UIColor.red
                  
                  let osPlatForm = CustomField(fieldId: 4419801704337, value: "iOS")
                  // let osVersion = CustomField(fieldId: 4419806853649, value: dic!["osVersion"] as? String)
                  // let devModel = CustomField(fieldId: 4419802058513, value: dic!["model"] as? String)
                  // let userId = CustomField(fieldId: 4419806761105, value:  dic!["id"] as? String)
                  // let appVersion  = CustomField(fieldId: 4419806867601, value: dic!["appVersion"] as? String)
                  let config = RequestUiConfiguration()
                  config.customFields = [osPlatForm]
                  let helpCenter = RequestUi.buildRequestList(with: [config])                  
                             let rootViewController:UIViewController! = UIApplication.shared.keyWindow?.rootViewController
                                   if (rootViewController is UINavigationController) {
                                       (rootViewController as! UINavigationController).pushViewController(helpCenter, animated:true)
                                   } else {
                                       let navigationController:UINavigationController! = UINavigationController(rootViewController:helpCenter)
                                     rootViewController.present(navigationController, animated:true, completion:nil)
                                   }
                break;
       default:
           print("Invalid method call!")
           break;
       
       }
  
  }

   func initSupport(dictionary: Dictionary<String, Any>) {
            guard let urlString = dictionary["urlString"] as? String,
                  let appId = dictionary["appId"] as? String,
                  let clientId = dictionary["clientId"] as? String,
                  let nameIdentifier = dictionary["nameIdentifier"] as? String
          
          
        else { return }

            Zendesk.initialize(appId: appId, clientId: clientId, zendeskUrl: urlString)
            let identity = Identity.createJwt(token: nameIdentifier)
        
            Zendesk.instance?.setIdentity(identity)
            Support.initialize(withZendesk: Zendesk.instance)
            
    
        }
}
