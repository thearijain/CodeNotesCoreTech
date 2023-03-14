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

class ViewController: UIViewController, SyntaxTextViewDelegate {
    
    let textView = SyntaxTextView()
    let imageView = UIImageView(image: UIImage(named: "def_main")!)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupTextView()
        setupImage()
        detectTextWithApple(image: imageView.image!)
    }

    
    func detectTextWithApple(image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
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
        
        
        for observation in observations {
//            print("=== ", observation.boundingBox)
            print("=== new observation")
            
            guard let candidate = observation.topCandidates(1).first else { continue }
            print("=== \t", candidate.string)
            addCGRect(frame: observation.boundingBox)
            print("=== \t bounding box of observation : ", observation.boundingBox)
            
//            if let range = candidate.string.range(of: "def") {
//                do {
//                    let boundingBoxForRange = try candidate.boundingBox(for: range)
//                    print("=== \t\tbox for DEF: ", boundingBoxForRange!.boundingBox.height)
//                    addCGRect(frame: boundingBoxForRange!.boundingBox)
//                } catch {
//                    print("=== \t\tL")
//                }
//            }
//            print()
//            if let range = candidate.string.range(of: "main") {
//                do {
//                    let boundingBoxForRange = try candidate.boundingBox(for: range)
//                    print("=== \t\tbox for MAIN: ", boundingBoxForRange!.boundingBox.height)
//                    addCGRect(frame: boundingBoxForRange!.boundingBox)
//                } catch {
//                    print("=== \t\tL")
//                }
//            }
            print()
        }
        
        let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
    }
    
    // Adds a CGRect to the image view
    func addCGRect(frame: CGRect) {
        let viewToAdd = UIView(frame: frame)
//        let viewToAdd = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        viewToAdd.backgroundColor = .cyan
        viewToAdd.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.addSubview(viewToAdd)
    }
    
    func setupTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(textView)
        textView.theme = DefaultSourceCodeTheme()
        textView.delegate = self
        
//        NSLayoutConstraint.activate([
//            textView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            textView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
//            textView.heightAnchor.constraint(equalToConstant: 300),
//            textView.widthAnchor.constraint(equalToConstant: 300)
//        ])
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
            imageView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
        ])
    }
    
    func lexerForSource(_ source: String) -> Sourceful.Lexer {
        return Python3Lexer()
    }
}

