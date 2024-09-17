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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Update to use your document name.
        let fileURL = Bundle.main.url(forResource: "blank", withExtension: "pdf")!
        let document = Document(url: fileURL)

        // The configuration closure is optional and allows additional customization.
        let pdfController = PDFViewController(document: document) {
            $0.isPageLabelEnabled = false
        }

        let nav = UINavigationController(rootViewController: pdfController)
        nav.modalPresentationStyle = .fullScreen
        // Present the PDF view controller within a `UINavigationController` to show built-in toolbar buttons.
        present(nav, animated: true)
    }
}

