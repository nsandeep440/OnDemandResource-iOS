//
//  BundleRequest.swift
//  OdrDemo
//
//  Created by Sandeep Nakka on 10/11/19.
//  Copyright © 2019 Sandeep Nakka. All rights reserved.
//

import Foundation

class ODRRequest: NSObject {
    
    private var request: NSBundleResourceRequest?
    private var progressCallback: ((_ progress: Progress) -> Void)?
    
    func downloadResource(tag: String, completion: @escaping ((_ success: Bool, _ error: Error?) -> Void)) {
        self.request = NSBundleResourceRequest(tags: [tag], bundle: Bundle.main)
        
        self.request?.conditionallyBeginAccessingResources { (resourceAvailable) in
            guard !resourceAvailable else {
                print("Resource already available")
                completion(true, nil)
                return
            }            
            print("Started downloading resouce for tag: \(tag)")
            self.request?.beginAccessingResources { (err) in
                guard err == nil else {
                    print("Error downloading resouce: \(err?.localizedDescription ?? "")")
                    completion(false, err)
                    return
                }
                print("Completed downloading image")
                completion(true, nil)
            }
        }
    }
    
    func endRequest() {
        self.request?.progress.cancel()
        if self.request != nil {
            self.request?.endAccessingResources()
            self.request?.progress.removeObserver(self, forKeyPath: "fractionCompleted")
        }
        self.request = nil
        self.progressCallback = nil
    }
    
    func trackProgressIfNeeded() {
        guard self.progressCallback != nil else { return }
        self.request?.progress.addObserver(self, forKeyPath: "fractionCompleted", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keypath = keyPath, keypath == "fractionCompleted" else { return }
        if let req = self.request {
            self.progressCallback?(req.progress)
        }
    }
}


//
//
//typealias ProgressCallback = (_ progess: Progress) -> Void
//
//class ODRRequest: NSObject {
//    private var request: NSBundleResourceRequest!
//    private var progress: ProgressCallback?
//
//    /// This method will download resource if needed for tag passed.
//    ///
//    /// - Parameters:
//    ///   - tag: String - Resource tag name
//    ///   - progress: ProgressHandler - Will called on fraction completion value change
//    ///   - completion: CompletionHandler - Will be called on completion of downloading/already available
//    func downloadResource(tag:String, progress:ProgressHandler?, completion: CompletionHandler?) {
//
//        self.request = NSBundleResourceRequest(tags: [tag], bundle: Bundle.main)
//
//        // persist progress handler and track progress if needed
//        self.progress = progress
//        self.trackProgressIfNeeded()
//
//        //  check and download resources
//        self.request.conditionallyBeginAccessingResources { (isAvailable) in
//
//            if isAvailable {
//                // resource available
//                Logger.debug("Resource with tag \(tag) is already downloaded,")
//                completion?(nil)
//                self.end()
//            }
//            else {
//                Logger.debug("Downloading resource with tag \(tag)")
//                self.request.beginAccessingResources(completionHandler: { (error) in
//
//                    Logger.debug("Downloading resource completed")
//
//                    if let _error = error {
//                        Logger.debug(_error.localizedDescription)
//                    }
//                    completion?(error)
//                    self.end()
//                })
//            }
//        }
//    }
//
//    func cancel() {
//        // cancel request
//        self.request.progress.cancel()
//
//        self.end()
//    }
//
//    private func trackProgressIfNeeded() {
//
//        if self.progress != nil {
//            self.request.progress.addObserver(self, forKeyPath: ProgressTrackerKey, options: .new, context: nil)
//        }
//    }
//
//    private func end() {
//
//
//        if self.request != nil {
//            // end access
//            self.request.endAccessingResources()
//
//            // remove tracking observer
//            self.request.progress.removeObserver(self, forKeyPath: ProgressTrackerKey)
//        }
//
//        // clean properties
//        self.request = nil
//        self.progress = nil
//    }
//
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//
//        if let keyPath = keyPath, keyPath == ProgressTrackerKey {
//
//            self.progress?(self.request.progress)
//        }
//    }
//}
