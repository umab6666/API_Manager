//
//  WebServiceManager.swift
//  Pert
//
//  Created by Vardhan@Sw!tch on 22/02/17.
//  Copyright © 2017 SwitchSoft. All rights reserved.
//

import UIKit
public enum MethodType {
    case GET,POST,PUT,DELETE
    
    public func getMethodName() -> String {
        switch self {
        case .GET:
            return "GET"
        case .POST:
            return "POST"
        case .PUT:
            return "PUT"
        case .DELETE:
            return "DELETE"
        }
    }
}
public typealias successBlock = (_ result:Any) -> Void
public typealias failureBlock = (_ errMsg:String) -> Void
let BASEURL = ""
public class WebServiceManager: NSObject {
   public static let shared = WebServiceManager()
    
    private override init() {
        
    }
    public func parseData(urlStr:String,parameters:Any?,method:MethodType,flg:NSInteger ,successHandler:@escaping successBlock,failureHandler:@escaping failureBlock){
        
        let url = URL(string: urlStr.replacingOccurrences(of: " ", with: "%20"))
        var request = URLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringCacheData
        
        request.httpMethod = method.getMethodName()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if(parameters != nil) {
            request.httpBody = self.convertParametersToData(parms: parameters! as AnyObject) as Data?
        }
        self.callWebservice(request: request) { (result, errMsg) in
            if errMsg == nil {
                successHandler(result as Any)
            }else{
                failureHandler(errMsg! as String)
            }
        }
    }
    fileprivate
     func callWebservice(request:URLRequest,completionBlock:@escaping (Any?,String?) -> () ){
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, err) in
            if err == nil {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    DispatchQueue.main.async {
                        completionBlock(result,nil)
                    }
                }
                catch let JSONError as NSError{
                    completionBlock(nil,JSONError.localizedDescription)
                }
                
            }else{
                completionBlock(nil,err?.localizedDescription)
            }
            
            }.resume()
    }
    private
     func convertParametersToData(parms:AnyObject) -> NSData?{
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parms, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonStr = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
            return jsonStr!.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) as NSData?
        }catch _ as NSError{
            // print("JSON ERROR\(err.localizedDescription)")
        }
        catch {
            // Catch any other errors
        }
        return nil
    }
    //    class func updateProfileImage(img : UIImage ,url: String,completionHander:@escaping successBlock ,FailureHandler:@escaping failureBlock)
    //    {
    //        let urlstr = url
    //        let imgdata : NSData = UIImageJPEGRepresentation(img, 0.5)! as NSData
    //        let request = NSMutableURLRequest(url: NSURL(string:urlstr)! as URL)
    //        request.httpMethod = "POST"
    //        let boundary = NSString(format: "---------------------------14737809831466499882746641449")
    //        let contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
    //        //  println("Content Type \(contentType)")
    //        request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
    //        let body = NSMutableData()
    //
    //        // Title
    //        body.append(NSString(format: "\r\n--%@\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
    //        body.append(NSString(format:"Content-Disposition: form-data; name=\"title\"\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
    //        body.append("ProfileImage".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
    //
    //        // Image
    //        body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
    //        body.append(NSString(format:"Content-Disposition: form-data; name=\"ProfileImage\"; filename=\"img\"\r\n").data(using: String.Encoding.utf8.rawValue)!)
    //        body.append(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
    //        body.append(imgdata as Data)
    //        body.append(NSString(format: "\r\n--%@--\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
    //
    //        //username
    ////        body.append(NSString(format: "--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
    ////        body.append(NSString(format: "Content-Disposition: form-data; name=\"username\"\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
    ////    //    body.appendData(GlobalMethods.getUserName().dataUsingEncoding(NSUTF8StringEncoding)!)
    ////        body.append("\r\n".data(using: String.Encoding.utf8)!)
    //
    //
    //        //password
    ////        body.append(NSString(format: "--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
    ////        body.append(NSString(format: "Content-Disposition: form-data; name=\"password\"\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
    ////       // body.appendData(GlobalMethods.getPassword().dataUsingEncoding(NSUTF8StringEncoding)!)
    ////        body.append("\r\n".data(using: String.Encoding.utf8)!)
    ////
    //        request.httpBody = body as Data
    //
    //        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main, completionHandler: { (response, data, err) -> Void in
    //            if (err == nil){
    //                let returnString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
    //                completionHander(resultDict: returnString!)
    //               // WebServices.showProgressiveHud(false, loadingTxt: "Loading")
    //            }else{
    //                // print(err?.localizedDescription)
    //                FailureHandler((err?.localizedDescription)!)
    //               // Webservices.showProgressiveHud(false,loadingTxt: "Loading")
    //            }
    //        })
    //    }
    public func uploadFile(_ urlStr:NSString,img:UIImage,folderName: String ,flg:NSInteger,successHander:@escaping successBlock,FailureHander:@escaping failureBlock){
        // Webservices.showProgressiveHud(true, loadingTxt: "")
        let url = URL(string:BASEURL + ((urlStr as NSString) as String) as String)
        var request = URLRequest(url:url!)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        //define the multipart request type
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let image_data = img.jpegData(compressionQuality: 0.5)
        let body = NSMutableData()
        let fname = "businesspics.jpg"
        let mimetype = "image/jpg"
        //define the data post parameter
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(image_data!)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: {
            (
            data, response, error) in
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                FailureHander((error!.localizedDescription as NSString) as String)
                //  Webservices.showProgressiveHud(false, loadingTxt: "")
                return
            }
            if error == nil
            {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments)
                    DispatchQueue.main.async(execute: {
                        successHander(result as AnyObject)
                        //       Webservices.showProgressiveHud(false, loadingTxt: "")
                        
                    })
                }
                catch let JSONError as NSError{
                    FailureHander((JSONError.localizedDescription as NSString) as String)
                    //         Webservices.showProgressiveHud(false, loadingTxt: "")
                }
            }
            else{
                FailureHander((error!.localizedDescription as NSString) as String)
                
                //      Webservices.showProgressiveHud(false, loadingTxt: "")
            }
        }) .resume()
        
    }
}


