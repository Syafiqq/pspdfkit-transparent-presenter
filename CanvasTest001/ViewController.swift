//
//  ViewController.swift
//  CanvasTest001
//
//  Created by engineering on 21/7/24.
//

import UIKit
import PSPDFKit
import PSPDFKitUI
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let nav = UINavigationController(rootViewController: ViewController1())
        nav.modalPresentationStyle = .fullScreen

        present(nav, animated: true)
    }
}

class ViewController1: UIViewController {

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

        guard let documentURL else {
            return
        }

        // Create a configuration for an empty A4 size page with a white background color.
        let newPageConfiguration = PDFNewPageConfiguration(pageTemplate: PageTemplate.blank) {
            $0.backgroundColor = UIColor.white
            $0.pageSize = CGSize(width: self.view.frame.width, height: 500) // A4 in points.
        }

        let timestamp = Int(Date().timeIntervalSince1970)
        let filename = "pdf-\(timestamp).pdf"
        let saveToPath = documentURL.appendingPathComponent(filename)

        let configuration = Processor.Configuration()
        configuration.addNewPage(at: 0, configuration: newPageConfiguration)

        // Save to a new PDF file.
        let processor = Processor(configuration: configuration, securityOptions: nil)
        do {
            try processor.write(toFileURL: saveToPath)
        } catch {
            print(error)
        }

        let pdfController = PDFViewController(document: Document(url: saveToPath)) {
            $0.isPageLabelEnabled = false
        }

        addChild(pdfController)

        pdfController.view.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(pdfController.view)
        pdfController.view.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(500)
        }
        view.isOpaque = false
        view.backgroundColor = .white
        pdfController.didMove(toParent: self)

        // If not in document view mode, it'll be weird.
        pdfController.setViewMode(.document, animated: true)
        pdfController.annotationToolbarController?.updateHostView(nil, container: nil, viewController: pdfController)
        UsernameHelper.ask(forDefaultAnnotationUsernameIfNeeded: pdfController, completionBlock: { _ in
            pdfController.annotationToolbarController?.toggleToolbar(animated: true)
        })
    }
}

