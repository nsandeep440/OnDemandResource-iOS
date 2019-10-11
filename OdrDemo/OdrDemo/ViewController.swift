//
//  ViewController.swift
//  OdrDemo
//
//  Created by Sandeep Nakka on 10/10/19.
//  Copyright © 2019 Sandeep Nakka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let odrRequest = ODRRequest()

    @IBOutlet weak var imageViewTagOne: UIImageView!
    @IBOutlet weak var imageViewTagTwo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func actionTagOne(_ sender: UIButton) {
        let tagName = "inital"
        odrRequest.downloadResource(tag: tagName) { [weak self] (resourceAvailable, error) in
            guard error == nil else { return }
            if resourceAvailable {
                DispatchQueue.main.async {
                    if let strongSelf = self {
                        strongSelf.imageViewTagOne.image = UIImage(named: "image-swift")
                    }
                }
            }
        }
    }
    
    @IBAction func actionTagTwo(_ sender: UIButton) {
        let tagName = "prefetch"
        odrRequest.downloadResource(tag: tagName) { [weak self] (resourceAvailable, error) in
            guard error == nil else { return }
            if resourceAvailable {
                DispatchQueue.main.async {
                    if let strongSelf = self {
                        strongSelf.imageViewTagTwo.image = UIImage(named: "image-swiftbook")
                    }
                }
                
            }
        }
    }
    
    @IBAction func actionPurge(_ sender: Any) {
    }
    
    @IBAction func actionNext(_ sender: Any) {
    }
    
}

