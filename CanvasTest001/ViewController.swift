//
//  ViewController.swift
//  CanvasTest001
//
//  Created by engineering on 21/7/24.
//

import UIKit
import PSPDFKit
import PSPDFKitUI

class ViewController: UIViewController {

    private var documentURL: URL? {
        try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print("CurrentLog - path - \(documentURL?.path ?? "nil")")
    }
}

