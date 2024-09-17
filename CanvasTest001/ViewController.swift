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
    private var btSavePng: UIButton!
    private var document: Document!
    private var pdfController: PDFViewController!

    private var documentURL: URL? {
        try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
    }

    @objc func saveAnswer() {
        guard let documentURL else {
            return
        }
        let timestamp = Int(Date().timeIntervalSince1970)
        let filename = "answer-\(timestamp).png"
        let saveToPath = documentURL.appendingPathComponent(filename)

        let pageIndex: PageIndex = 0
        let imageSize = CGSize(width: view.frame.width, height: 500)
        let clippedSize = CGRect(origin: CGPoint(x: 0, y: 250), size: CGSize(width: view.frame.width, height: 250))

        let renderOptions = RenderOptions()

        if let renderedImage = try? document.imageForPage(at: pageIndex, size: imageSize, clippedTo: clippedSize, annotations: nil, options: renderOptions) {

            let imageData = renderedImage.pngData()
            try? imageData?.write(to: saveToPath)

            print("Saved annotated image to: \(saveToPath.absoluteString)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initDesign()
        btSavePng.setTitle("Save Answer", for: .normal)
        btSavePng.addTarget(self, action: #selector(saveAnswer), for: .touchUpInside)
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

        let document = Document(url: saveToPath)
        let pdfController = PDFViewController(document: document) {
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

        self.document = document
        self.pdfController = pdfController
    }
}

extension ViewController1 {
    func initDesign() {
        // MARK: View Initialization
        let svButtonContainer = generateStackViewForContainerDesign()
        let btSavePng = generateButtonDesign()

        view.addSubview(svButtonContainer)
        svButtonContainer.addArrangedSubview(btSavePng)

        // MARK: View Constraints
        svButtonContainer.snp.makeConstraints({
            $0.bottom.leading.equalToSuperview()
                .offset(-16)
        })

        // MARK: View Assign
        self.btSavePng = btSavePng
    }

    private func generateStackViewForContainerDesign() -> UIStackView {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 8
        return view
    }

    private func generateButtonDesign() -> UIButton {
        let view = UIButton(type: .system)
        view.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.backgroundColor = .green
        view.setTitleColor(.black, for: .normal)
        return view
    }
}
