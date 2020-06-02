//
//  BundleRequest.swift
//  OdrDemo
//
//  Created by Sandeep Nakka on 10/11/19.
//  Copyright © 2019 Sandeep Nakka. All rights reserved.
//

import Foundation

typealias ProgressCallback = (_ progess: Progress) -> Void

class ODRRequest: NSObject {
    
    private var request: NSBundleResourceRequest?
    private var progressCallback: ProgressCallback?
    
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
