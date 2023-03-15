//
//  ViewController.swift
//  TextRecognitionPractice
//
//  Created by Ari Jain on 3/11/23.
//

import UIKit
import Vision
import VisionKit
import Sourceful
import PencilKit

class ViewController: UIViewController, SyntaxTextViewDelegate {
    
    
    let textView = SyntaxTextView()
    let imageView = UIImageView(image: UIImage(named: "def_main")!)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImage()
        detectTextWithApple(image: imageView.image!)
    }
    
    
    func detectTextWithApple(image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        let requestHandler = VNImageRequestHandler(
            cgImage: cgImage
        )
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        request.customWords.append(contentsOf: ["(", ")", ":", ";", "[", "]", "=", "i", "\""])
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
        
    }
    
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }
        print()
        var boundingBoxes: [CGRect] = []
        
        
        for observation in observations {
            print("=== new observation")
            
            guard let candidate = observation.topCandidates(1).first else { continue }
            print("=== \t", candidate.string)
            
            if let range = candidate.string.range(of: "def") {
                do {
                    let boundingBoxForRange = (try candidate.boundingBox(for: range))!
                    boundingBoxes.append(boundingBoxForRange.boundingBox)
                } catch {
                    print("=== \t\tL")
                }
            }
            if let range = candidate.string.range(of: "main") {
                do {
                    let boundingBoxForRange = (try candidate.boundingBox(for: range))!
                    boundingBoxes.append(boundingBoxForRange.boundingBox)
                } catch {
                    print("=== \t\tL")
                }
            }
            print()
        }
        
        
        let result = visualization(image: imageView.image!, boundingBoxes: boundingBoxes)
        imageView.image = result
    }
    
    func setupTextView() {
        textView.theme = DefaultSourceCodeTheme()
        textView.delegate = self
        textView.text = "def main():\n"
//        textView.text += "\tnode = Node(val=5)\n"
//        textView.text += "\tfor i in range(0, 10):\n"
//        textView.text += "\t\tprint(\"hello: \", node.val)"
    }
    
    func setupImage() {
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 500),
            imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
        ])
    }
    
    func lexerForSource(_ source: String) -> Sourceful.Lexer {
        return Python3Lexer()
    }
    
    func visualization(image: UIImage, boundingBoxes: [CGRect]) -> UIImage {
        var transform = CGAffineTransform.identity
            .scaledBy(x: 1, y: -1)
            .translatedBy(x: 1, y: -image.size.height)
        transform = transform.scaledBy(x: image.size.width, y: image.size.height)

        UIGraphicsBeginImageContextWithOptions(image.size, true, 0.0)
        let context = UIGraphicsGetCurrentContext()

        image.draw(in: CGRect(origin: .zero, size: image.size))
        context?.saveGState()

        context?.setLineWidth(2)
        context?.setLineJoin(CGLineJoin.round)
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setFillColor(red: 0, green: 1, blue: 0, alpha: 0.3)

        boundingBoxes.forEach { boundingBox in
            // MARK: This is the correct bounds we need !
            let bounds = boundingBox.applying(transform)
            context?.addRect(bounds)
        }

        context?.drawPath(using: CGPathDrawingMode.fillStroke)
        context?.restoreGState()
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage!
    }
}

